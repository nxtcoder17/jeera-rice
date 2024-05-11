#! /bin/sh

email=$1
shift 1
[ -z $email ] && echo "need to specify email as argument, exiting ..." && exit 1
echo "signing commits for user with email: ${email}"

echo "need to execute this command"
cat <<'EOF'
git filter-branch -f --commit-filter 'if [ "$GIT_COMMITTER_EMAIL" = "$YOUR_EMAIL" ];
  then git commit-tree -S "$@";
  else git commit-tree "$@";
fi' HEAD
EOF
