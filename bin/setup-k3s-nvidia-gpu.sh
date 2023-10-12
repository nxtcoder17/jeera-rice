#! /usr/bin/env bash

HELM_VERSION="v3.13.0"
OS="linux"
ARCH="amd64"

KUBECTL="${KUBECTL:-k3s kubectl}"
export KUBECONFIG="${KUBECONFIG:-"/etc/rancher/k3s/k3s.yaml"}"

manifests_dir="./manifests"
scripts_dir="./scripts"

mkdir -p $manifests_dir
mkdir -p $scripts_dir

echo "[#] add nvidia repository to apt sources"
echo "[#]   sources: https://github.com/NVIDIA/k8s-device-plugin#install-the-nvidia-container-toolkit"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/libnvidia-container.list

echo "[#] installing nvidia container runtime"
echo "[#]     source: https://docs.k3s.io/advanced#nvidia-container-runtime-support"
sudo apt install -y nvidia-container-runtime

echo "[#] creating runtime class"
echo "[#]     source: https://docs.k3s.io/advanced#nvidia-container-runtime-support"
cat > $manifests_dir/runtime-class.yml <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: nvidia
handler: nvidia
EOF
$KUBECTL apply -f $manifests_dir/runtime-class.yml

echo "[#] installing helm if not exists"
if ! (command -v helm &> /dev/null); then
  tdir=$(mktemp -d)
  pushd $tdir
  curl -L0 https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz > helm.tar.gz
  tar xf helm.tar.gz
  mv ${OS}-${ARCH}/helm /usr/local/bin/helm
  popd
  # rm -rf "$tdir"
fi

echo "[#] installing nvidia device plugin with helm"
echo "[#]     source: https://github.com/NVIDIA/k8s-device-plugin#deployment-via-helm"
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
helm repo update nvdp

ns_nvdp="kl-nvidia-device-plugin"

helm upgrade -i nvdp nvdp/nvidia-device-plugin \
  --namespace ${ns_nvdp} \
  --create-namespace \
  --version 0.14.1 \
  --set runtimeClassName=nvidia

echo "[#] for device plugin logs,  run: '${KUBECTL} logs -n ${ns_nvdp} -l app.kubernetes.io/instance=nvdp'"

echo "[#] installing test-gpu pod to test nvidia runtime"
echo "[#]     source: https://docs.k3s.io/advanced#nvidia-container-runtime-support"
cat > $manifests_dir/test-gpu-pod.yml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nbody-gpu-benchmark
  namespace: default
spec:
  restartPolicy: OnFailure
  runtimeClassName: nvidia
  containers:
  - name: cuda-container
    image: nvcr.io/nvidia/k8s/cuda-sample:nbody
    args: ["nbody", "-gpu", "-benchmark"]
    resources:
      limits:
        nvidia.com/gpu: 1
    env:
    - name: NVIDIA_VISIBLE_DEVICES
      value: all
    - name: NVIDIA_DRIVER_CAPABILITIES
      value: all
EOF

$KUBECTL apply -f $manifests_dir/test-gpu-pod.yml
echo "[#] for test-gpu pod logs, run: '${KUBECTL} logs -n default pods/nbody-gpu-benchmark'"

sudo systemctl restart k3s.service
 
