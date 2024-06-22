function kill-port --description "kills-tcp-port"
  for port in $argv
    kill -9 (lsof -i tcp:$port | tail -n +2 | awk '{print $2}')
  end
end

