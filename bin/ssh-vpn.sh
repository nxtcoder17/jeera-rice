kubectl run kuttle --image=alpine:latest --restart=Never -- sh -c 'apk add python3 --update && exec tail -f /dev/null'
sshuttle --dns -r kuttle -e kuttle 0.0.0.0/0

