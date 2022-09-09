
function kill-port --description "kills-tcp-port"
  for port in $argv
    kill (lsof -i tcp:$port | tail +2 | awk '{print $2}')
  end
end
