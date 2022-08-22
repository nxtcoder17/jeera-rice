
function kill-port --description "kills-tcp-port"
  for port in $argv
    kill (lsof -i tcp:$port)
  end
end
