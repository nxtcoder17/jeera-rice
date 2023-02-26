function kill-port --description "kills-tcp-port"
  for port in $argv
    kill (lsof -i tcp:$port | tail +2 | awk '{print $2}')
  end
end

function source-env --description "sources an env file"
 set lines (cat $argv | rg -P '^(?!#)' | rg -P '^(?!\s*$)' | sed 's/export\s*//g')
 for line in $lines
   set item (string split -m 1 '=' $line)
   set value (string trim --chars=\'\" $item[2])
   set -gx $item[1] $value
 end
end
