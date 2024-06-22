function to-git-root
  set -l dir $argv[1]
  if [ -z "$dir" ]
    set dir .
  end

  if [ -d "$dir/.git" ]
    pushd $dir
    return
  else
    to-git-root $dir/..
  end
end
