#! /usr/bin/env bash

namespace="wireguard"
deployment_name="wireguard"

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
  privatekey: 4N9FtwbtC9iY9P1C85l1QmM0OxlGRT0cHVjEuRbLuVA=
  wg0.conf.template: |
    [Interface]
    Address = 10.13.13.1
    ListenPort = 51820
    # PrivateKey = COpReLCsOrklOpSlE+n1f/qGENMo07lmssH9LMH4Vks=
    PrivateKey = 4N9FtwbtC9iY9P1C85l1QmM0OxlGRT0cHVjEuRbLuVA=
    PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE

    # [Interface]
    # Address = 172.16.16.0/20
    # ListenPort = 51820
    # PrivateKey = OIviMX9BPHk1w/bvsXW0Qc2/mY3+HS3iS31aEtsn+Uc=
    # PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ENI -j MASQUERADE
    # PostUp = sysctl -w -q net.ipv4.ip_forward=1
    # PostUp = sysctl -w -q net.ipv4.conf.all.forwarding=1
    # PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ENI -j MASQUERADE
    # PostDown = sysctl -w -q net.ipv4.ip_forward=0
    # PostDown = sysctl -w -q net.ipv4.conf.all.forwarding=0

    [Peer]
    # Example Peer 1
    PublicKey = 6LaKVAr7GSrKfUZ2LQTN4H3SiAtGcBEf88GmxMQnn2I=
    AllowedIPs = 0.0.0.0/0
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
      initContainers:
        # The exact name of the network interface needs to be stored in the
        # wg0.conf WireGuard configuration file, so that the routes can be
        # created correctly.
        # The template file only contains the "ENI" placeholder, so when
        # bootstrapping the application we'll need to replace the placeholder
        # and create the actual wg0.conf configuration file.
        - name: "wireguard-template-replacement"
          image: "busybox"
          command: 
            - "sh"
            - "-c"
            - |+
              ENI=\$(ip route get 8.8.8.8 | grep 8.8.8.8 | awk '{print \$5}')
              echo "ENI: \$ENI"
              sed s/ENI/\$ENI/g /etc/wireguard-secret/wg0.conf.template > /etc/wireguard/wg0.conf
              chmod 400 /etc/wireguard/wg0.conf
              # cp /etc/wireguard-secret/wg0.key /etc/wireguard/wg0.key
          volumeMounts:
            - name: wireguard-config
              mountPath: /etc/wireguard/
            - name: wireguard-secret
              mountPath: /etc/wireguard-secret/

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
              echo "Public key '\$(wg pubkey < /tmp/privatekey)'"

              ln -sf /tmp/wg0.conf /etc/wireguard/wg0.conf
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
            - name: wireguard-config
              mountPath: /tmp/wg0.conf
              subPath: wg0.conf
              readOnly: false
            - name: wireguard-secret
              mountPath: /tmp/privatekey
              subPath: privatekey
              readOnly: true
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
