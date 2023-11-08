function kill-port --description "kills-tcp-port"
  for port in $argv
    kill (lsof -i tcp:$port | tail -n +2 | awk '{print $2}')
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

function curl-cookie --description "curl sets up cookie"
  curl -s -L0 (cat ~/.kl-cookies | xargs -I{} echo -n '--cookie {}' | xargs -n1) "$argv"
end

# function go-test-cover --description "go test with coverprofile and opening that profile in browser"
#   set -l coverprofile (mktemp)
#   go test -coverprofile=$coverprofile $argv
#   go tool cover -html=$coverprofile
#   [ ! -z $coverprofile ] && rm -rf "$coverprofile"
# end
