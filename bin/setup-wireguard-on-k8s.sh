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
    # PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    # PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

    [Peer]
    PublicKey = 4/j7pTZlVcjnDlHTdZVwo1O8uTEuyJmo+nc3/+XQRik=
    AllowedIPs = 10.0.0.2/32

    [Peer]
    PublicKey = D/3sx7t4JNI33nJ4taOOza3gLtgr/r3VUaL/NlGzLgI=
    AllowedIPs = 10.0.0.3/32

    [Peer]
    PublicKey = N6dJwMa1rxFvoLaPqbOpVtSiBqPg5L1vHCTg7DRYGyY=
    # AllowedIPs = 10.0.0.4/32
    AllowedIPs = fd12:3456:789a::2/48

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
    Address = fd12:3456:789a::2/48
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
              mkdir -p /config/wg_confs
              cp /tmp/wireguard/server.conf /config/wg_confs/wg0.conf
              wg-quick up wg0
              # wg-quick down wg0
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
            # privileged: true
            capabilities:
              add:
                - NET_ADMIN
                - SYS_ADMIN

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
shift 1

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
	pushd $dir >/dev/null 2>&1 || exit 1
	wg genkey | tee private.key | wg pubkey >public.key

	cat >peer.conf <<EOF
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
	popd >/dev/null 2>&1 || exit 1
	;;
*)
	echo "Unknown command $cmd, only install|generate-peer supported"
	;;
esac
