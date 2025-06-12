#! /bin/sh
email=$1
shift 1
[ -z $email ] && echo "need to specify email as argument, exiting ..." && exit 1
echo "signing commits for user with email: ${email}"

echo "need to execute this command"
# cat <<'EOF'
git filter-branch -f --commit-filter "if [ '$GIT_COMMITTER_EMAIL' = '$email' ];
  then git commit-tree -S 'AC3E1DC704682E26B188E3C4E673FDEF510664E8' "$@";
  else git commit-tree '$@';
fi" HEAD
# EOF
