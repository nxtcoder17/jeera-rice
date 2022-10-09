#! /usr/bin/env bash

namespace=$1
newNamespace=$2

kubectl get configmaps -n $namespace -o json | yq --arg newNs=$newNamespace '
  .items|
    map(
      del(.metadata.creationTimestamp) |
      del(.metadata.resourceVersion) |
      del(.metadata.uid) |
      del(.metadata.ownerReferences) |
      del(.status) |
      .metadata.namespace = $newNs
    ) | 
  .[]
' -y


kubectl get secrets -n $namespace -o json | yq --arg newNs=$newNamespace '
  .items|
    map(
      del(.metadata.creationTimestamp) |
      del(.metadata.resourceVersion) |
      del(.metadata.uid) |
      del(.metadata.ownerReferences) |
      del(.status) |
      .metadata.namespace = $newNs 
    ) | 
  .[]
' -y

kubectl get svc -n kl-core -o json | yq --arg newNs=$newNamespace '
  .items|
    map(
      del(.metadata.creationTimestamp) |
      del(.metadata.resourceVersion) |
      del(.metadata.uid) |
      del(.metadata.ownerReferences) |
      del(.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"]) |
      .spec = {
        type: "ExternalName",
        externalName: "\(.metadata.name).\(.metadata.namespace).svc.cluster.local"
      } |
      .metadata.namespace = $newNamespace |
      del(.status)
   ) | 
  .[]
' -y

# kubectl get ingresses -n kl-core -o json | yq '
#   .items |
#     map(
#       del(.metadata.creationTimestamp) |
#       del(.metadata.resourceVersion) |
#       del(.metadata.uid) |
#       del(.metadata.ownerReferences) |
#       del(.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"]) |
#       del(.status)
#     ) | .[] //empty
# ' -y
