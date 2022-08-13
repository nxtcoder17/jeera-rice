echo "$@" > /tmp/ol
podName=$1
echo "$1" >> /tmp/ol
shift 2;
echo "$@" >> /tmp/ol

echo exec kubectl exec -i $podName -- "$@" >> /tmp/ol
exec kubectl exec -i $podName -- $@

