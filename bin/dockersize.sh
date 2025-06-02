#! /usr/bin/env bash

args=()
debug=false
file=""
# echo "$#"
while [[ $# -gt 0 ]]; do
  # echo "here $#"
  case "$1" in
  -d | --debug)
    # echo "option: debug"
    debug=true
    ;;
  -f | --file)
    shift
    file=$1
    ;;
  --)
    args+=("$@")
    break
    ;;
  --*)
    # echo "Unknown option : $1"
    # break
    ;;
  -*)
    # echo "Unknown option: $1"
    exit 1
    ;;
  *)
    args+=("$1")
    # break
    ;;
  esac
  # echo "here"
  shift
done

# echo "args: ${args[*]}"

eval set -- ${args}

# echo "$1"
# exit 1

if [ -z "$file" ]; then
  manifest_file=$(mktemp --suffix '.manifest.yml')
  if ! $debug; then
    trap "rm $manifest_file" EXIT SIGINT SIGTERM
  fi
  docker manifest inspect -v "$1" >"$manifest_file"

  if $debug; then
    echo "manifest_file: $manifest_file"
  fi

  manifest_file_parsed=$(mktemp --suffix '.manifest.json')
  if $debug; then
    echo "manifest_file_parsed: $manifest_file_parsed"
  fi
  if ! $debug; then
    trap "rm $manifest_file_parsed" EXIT
  fi

  # echo "$manifest_file"
  # cat "$manifest_file" | jq '
  #  if type == "array" then
  #    . = map_values(. = {"\(.Descriptor.platform.architecture)": .})
  #  else
  #    . = {"\(.Descriptor.platform.architecture)": .}
  #  end' >"$manifest_file_parsed"

  cat "$manifest_file" | jq '
  if type != "array" then 
    . = [.]
  end' >"$manifest_file_parsed"

  file=$manifest_file_parsed
fi

jq -r 'map(select(.Descriptor.platform.os != "unknown")) | map_values(
  if .Descriptor.platform.os != "unknown" then
    if .Descriptor.mediaType == "application/vnd.oci.image.manifest.v1+json" then
      . = "\(.Descriptor.platform.os)/\(.Descriptor.platform.architecture) (\(.OCIManifest.layers[0].mediaType)) \(.OCIManifest.config.size + (.OCIManifest.layers | map_values(.size) |add))"
    elif .Descriptor.mediaType == "application/vnd.docker.distribution.manifest.v2+json" then
      . = "\(.Descriptor.platform.os)/\(.Descriptor.platform.architecture) (\(.OCIManifest.layers[0].mediaType))  \(.SchemaV2Manifest.config.size + (.SchemaV2Manifest.layers | map_values(.size) |add))"
    else
      . = "\(.Descriptor.mediaType)"
    end
  end
) | .[]' <"$file" | numfmt --to=iec --format '%.2f' --field 3 | column --table
