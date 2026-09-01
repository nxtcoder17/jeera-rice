function to-git-root
  set -l dir $argv[1]
  if [ -z "$dir" ]
    set dir .
  end

  set -l root (git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
  if test $status -eq 0
    pushd "$root"
  else
    echo "Not inside a Git repository." >&2
    return 1
  end
end
