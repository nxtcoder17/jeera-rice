#! /usr/bin/env bash

namespace="wireguard"
deployment_name="wireguard"

function install() {
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $namespace
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: wireguard
  namespace: $namespace
type: Opaque
stringData:
  server.privatekey: oDwnb4yjua5org92qlHu/tENnA0oDL2rFNOlqz7eKUY=
  server.publckey: OtV3mVnNaGQNLlUfZwH1j6EhsIWcuO5IWICU0LgsW1I=
  server.conf: |+
    [Interface]
    Address = 10.0.0.1/24
    ListenPort = 51820
    PrivateKey = oDwnb4yjua5org92qlHu/tENnA0oDL2rFNOlqz7eKUY=
    PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

    [Peer]
    PublicKey = 4/j7pTZlVcjnDlHTdZVwo1O8uTEuyJmo+nc3/+XQRik=
    AllowedIPs = 10.0.0.2/32

    [Peer]
    PublicKey = D/3sx7t4JNI33nJ4taOOza3gLtgr/r3VUaL/NlGzLgI=
    AllowedIPs = 10.0.0.3/32

    [Peer]
    PublicKey = N6dJwMa1rxFvoLaPqbOpVtSiBqPg5L1vHCTg7DRYGyY=
    AllowedIPs = 10.0.0.4/32

  client-1.privatekey: uIPH3Ij/9OdnPNLf8qLtK2qo1ZYsKuRfUX+GgXBGqVQ=
  client-1.publickey: 4/j7pTZlVcjnDlHTdZVwo1O8uTEuyJmo+nc3/+XQRik=
  client-1.conf: |+
    [Interface]
    Address = 10.0.0.2/24
    ListenPort = 51820
    PrivateKey = uIPH3Ij/9OdnPNLf8qLtK2qo1ZYsKuRfUX+GgXBGqVQ=

    [Peer]
    PublicKey = OtV3mVnNaGQNLlUfZwH1j6EhsIWcuO5IWICU0LgsW1I=
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint = 152.67.10.237:31820

  client-2.privatekey: 6FleMSBpj9Ebh3m7OR2X3hNDvo9EEEM78KIBsAFag0Q=
  client-2.publickey: D/3sx7t4JNI33nJ4taOOza3gLtgr/r3VUaL/NlGzLgI=
  client-2.conf: |+
    [Interface]
    Address = 10.0.0.3/24
    ListenPort = 51820
    PrivateKey = 6FleMSBpj9Ebh3m7OR2X3hNDvo9EEEM78KIBsAFag0Q=

    [Peer]
    PublicKey = OtV3mVnNaGQNLlUfZwH1j6EhsIWcuO5IWICU0LgsW1I=
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint = 152.67.10.237:31820

  client-3.privatekey: oO4wgbjTR0KqUUkzoOcgEJotYMPqMTsENyj3BJ0yiXM=
  client-3.publickey: N6dJwMa1rxFvoLaPqbOpVtSiBqPg5L1vHCTg7DRYGyY=
  client-3.conf: |+
    [Interface]
    Address = 10.0.0.4/24
    ListenPort = 51820
    PrivateKey = oO4wgbjTR0KqUUkzoOcgEJotYMPqMTsENyj3BJ0yiXM=

    [Peer]
    PublicKey = OtV3mVnNaGQNLlUfZwH1j6EhsIWcuO5IWICU0LgsW1I=
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint = 152.67.10.237:31820
EOF

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $deployment_name
  namespace: $namespace
spec:
  selector:
    matchLabels:
      name: $deployment_name
  template:
    metadata:
      labels:
        name: $deployment_name
    spec:
      # initContainers:
      #   # The exact name of the network interface needs to be stored in the
      #   # wg0.conf WireGuard configuration file, so that the routes can be
      #   # created correctly.
      #   # The template file only contains the "ENI" placeholder, so when
      #   # bootstrapping the application we'll need to replace the placeholder
      #   # and create the actual wg0.conf configuration file.
      #   - name: "wireguard-template-replacement"
      #     image: "busybox"
      #     command: 
      #       - "sh"
      #       - "-c"
      #       - |+
      #         ENI=\$(ip route get 8.8.8.8 | grep 8.8.8.8 | awk '{print \$5}')
      #         echo "ENI: \$ENI"
      #         sed s/ENI/\$ENI/g /etc/wireguard-secret/wg0.conf.template > /etc/wireguard/wg0.conf
      #         chmod 400 /etc/wireguard/wg0.conf
      #         # cp /etc/wireguard-secret/wg0.key /etc/wireguard/wg0.key
      #     volumeMounts:
      #       - name: wireguard-config
      #         mountPath: /etc/wireguard/
      #       - name: wireguard-secret
      #         mountPath: /etc/wireguard-secret/

      # containers:
      #   - name: wireguard
      #     image: masipcat/wireguard-go:latest
      #     securityContext:
      #       privileged: true
      #       capabilities:
      #         add:
      #         - NET_ADMIN
      #     ports:
      #       - containerPort: 51820
      #         protocol: UDP
      #     command:
      #       - sh
      #       - -c
      #       - echo "Public key '\$(wg pubkey < /etc/wireguard/privatekey)'" && /entrypoint.sh
      #     env:
      #       - name: LOG_LEVEL
      #         value: info
      #     volumeMounts:
      #     - name: wireguard-secret
      #       mountPath: /etc/wireguard/privatekey
      #       subPath: privatekey
      #       readOnly: true
      #     - name: wireguard-config
      #       mountPath: /etc/wireguard/wg0.conf
      #       subPath: wg0.conf
      #       readOnly: true

      containers:
        - name: "wireguard"
          image: "ghcr.io/linuxserver/wireguard"
          ports:
            - containerPort: 51820
          command:
            - sh
            - -c
            - |+
              trap 'exit 0' SIGTERM SIGINT
              # private_key=\$(cat /tmp/wireguard/privatekey)
              # echo "Public key '\$(wg pubkey < /tmp/wireguard/privatekey)'"
              #
              # # cat /tmp/wireguard/wg0.conf /tmp/wireguard/peers.conf | sed "s|%PRIVATE_KEY%|\$private_key|g" > /etc/wireguard/wg0.conf
              # # ln -sf /tmp/wireguard/wg0.conf /etc/wireguard/wg0.conf

              cp /tmp/wireguard/server.conf /etc/wireguard/wg0.conf
              wg-quick down wg0
              wg-quick up wg0
              tail -f /dev/null
          env:
            - name: "TZ"
              value: "Asia/Kolkata"
            # Keep the PEERS environment variable to force server mode
            - name: "PEERS"
              value: "example"
          volumeMounts:
            - name: wireguard-secret
              mountPath: /tmp/wireguard
          securityContext:
            privileged: true
            capabilities:
              add:
                - NET_ADMIN

      volumes:
        - name: wireguard-config
          emptyDir: {}
        - name: wireguard-secret
          secret:
            secretName: wireguard
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: wireguard
  namespace: $namespace
spec:
  type: NodePort
  ports:
    - name: wireguard
      port: 31820
      protocol: UDP
      targetPort: 51820
      nodePort: 31820
  selector:
    name: $deployment_name
EOF
}

cmd=$1
shift 1;

case $cmd in
  install)
    install
    ;;
  uninstall)
    kubectl delete deploy/$deployment_name -n $namespace
    kubectl delete secret/wireguard -n $namespace
    kubectl delete ns/wireguard
    ;;
  generate-peer)
    dir=~/me/.wireguard/peer-$1
    mkdir -p $dir
    pushd $dir > /dev/null 2>&1 || exit 1
    wg genkey | tee private.key | wg pubkey > public.key

    cat > peer.conf <<EOF
[Interface]
Address = 10.13.13.2
PrivateKey = $(cat ./private.key)
ListenPort = 51820
DNS = 10.13.13.1

[Peer]
PublicKey = $(cat ./public.key)
# Endpoint = ENDPOINT_IP:ENDPOINT_PORT
Endpoint = ENDPOINT_IP:31820
AllowedIPs = 0.0.0.0/0, ::/0
EOF
    popd > /dev/null 2>&1 || exit 1
    ;;
  *)
    echo "Unknown command $cmd, only install|generate-peer supported"
    ;;
esac
