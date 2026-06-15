#! /usr/bin/env bash
#
# git-worktree.sh — seamless git worktree management
#
# All paths are explicit; this script makes no assumption about where your
# worktrees live. All commands work from anywhere inside the main repo or
# any of its worktrees.
#
# Usage:
#   git-worktree.sh add <branch> <path> [base-ref]
#       Create a worktree at <path> for <branch>. If <branch> exists locally
#       it is checked out; else if origin/<branch> exists it is tracked;
#       else a new branch is created from [base-ref] (or origin/HEAD).
#
#   git-worktree.sh rm <path>
#       Remove the worktree at <path>. Also deletes the branch if merged.
#
#   git-worktree.sh ls
#       List worktrees.
#
#   git-worktree.sh refresh <branch> <path> [--merge <other>]
#       Wipe any existing worktree at <path> (and any worktree currently
#       holding <branch>), force-reset local <branch> to origin/<branch>,
#       and create a fresh worktree at <path>. With --merge, merge <other>
#       into the freshly-reset branch. Use this for weekly-reset upstreams
#       (e.g. channel/beta) to avoid rebase/conflict churn.
#
#   git-worktree.sh clean
#       Prune stale worktree entries.
#
#   git-worktree.sh doctor
#       Diagnose common worktree/fetch issues that cause "cannot lock ref"
#       or "is not a branch" failures. Reports findings and the exact fix
#       commands — does not modify anything on its own. Checks:
#         - stale .lock files under refs/
#         - case-collision branches (macOS case-insensitive FS)
#         - empty remote.origin.fetch refspec
#         - orphaned worktree entries

set -euo pipefail

### ANSI colors
setup_colors() {
  if [ -t 2 ]; then
    C_RED=$'\033[31m'
    C_YELLOW=$'\033[33m'
    C_GREEN=$'\033[32m'
    C_BLUE=$'\033[34m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_RESET=$'\033[0m'
  else
    C_RED='' C_YELLOW='' C_GREEN='' C_BLUE='' C_BOLD='' C_DIM='' C_RESET=''
  fi
}

setup_colors

### logger using ANSI colors
die() {
  printf '%serror:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2
  exit 1
}
warn() {
  printf '%swarn:%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2
}
info() {
  printf '%s%s%s\n' "$C_DIM" "$*" "$C_RESET" >&2
}
success() {
  printf '%s%s%s\n' "$C_GREEN$C_BOLD" "$*" "$C_RESET" >&2
}
hl() {
  printf '%s%s%s' "$C_BLUE$C_BOLD" "$*" "$C_RESET"
}

# Remove stale ref/index .lock files left behind by an interrupted git
# process (the "cannot lock ref ... File exists" error). Only deletes locks
# older than 60s so a genuinely-running concurrent git process is left alone.
# Returns 0 if it removed at least one lock, 1 otherwise.
clean_stale_locks() {
  local common
  common="$(git rev-parse --git-common-dir 2>/dev/null)" || return 1
  local found
  found="$(find "$common/refs" -name '*.lock' -mmin +1 2>/dev/null)"
  [ -f "$common/index.lock" ] &&
    [ -z "$(find "$common/index.lock" -mmin -1 2>/dev/null)" ] &&
    found="$found"$'\n'"$common/index.lock"
  found="$(printf '%s\n' "$found" | grep -v '^$' || true)"
  [ -n "$found" ] || return 1
  while IFS= read -r f; do
    warn "removing stale lock: $f"
    rm -f "$f"
  done <<<"$found"
  return 0
}

branch_exists() { git show-ref --verify --quiet "refs/heads/$1"; }
remote_branch_exists() { git ls-remote --exit-code --heads origin "$1" >/dev/null 2>&1; }

# Detect a git directory/file (D/F) ref conflict for a proposed branch name.
# Branches are stored as file paths under refs/heads/, so "a/b" is a FILE that
# needs "a" to be a DIRECTORY. It therefore conflicts with an existing branch
# "a" (file where a dir is needed) or "a/b/c" (dir where a file is needed).
# Prints the first conflicting existing branch name, or nothing.
df_conflict() {
  local want="$1" refs r
  refs="$(
    {
      git for-each-ref --format='%(refname:short)' refs/heads/
      git for-each-ref --format='%(refname:short)' refs/remotes/origin/ |
        sed 's@^origin/@@'
    } 2>/dev/null | sort -u
  )"
  while IFS= read -r r; do
    [ -z "$r" ] || [ "$r" = "$want" ] && continue
    # existing ref is an ancestor dir of want (e.g. r=AC-1033, want=AC-1033/v11)
    case "$want" in "$r"/*)
      printf '%s\n' "$r"
      return 0
      ;;
    esac
    # want is an ancestor dir of existing ref (e.g. want=AC-1033, r=AC-1033/v11)
    case "$r" in "$want"/*)
      printf '%s\n' "$r"
      return 0
      ;;
    esac
  done <<<"$refs"
  return 1
}

# Fetch a SINGLE branch into refs/remotes/origin/<branch>, instead of all of
# origin/*. On a large monorepo a plain `git fetch` refreshes every branch
# (100k+ objects); we only need the one we're about to check out.
fetch_one() {
  local b="$1"
  git fetch --quiet origin "+refs/heads/$b:refs/remotes/origin/$b" 2>/dev/null
}

# If <branch> is checked out in some worktree, print that worktree's path.
worktree_holding_branch() {
  local branch="$1"
  git worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree /{p=$2}
    /^branch /{if($2==b){print p; exit}}'
}

branch_in_worktree() {
  local path="$1"
  git -C "$path" symbolic-ref --short HEAD 2>/dev/null
}

# True if the worktree at <path> has uncommitted changes (staged, unstaged,
# or untracked).
worktree_is_dirty() {
  local path="$1"
  [ -n "$(git -C "$path" status --porcelain 2>/dev/null)" ]
}

default_branch() {
  git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@' || echo main
}

cmd_add() {
  [ $# -ge 2 ] || die "usage: add <branch> <path> [base-ref]"
  local branch="$1"
  local path="$2"
  local base="${3:-}"

  [ -e "$path" ] && die "path already exists: $path"

  # Pre-flight: a slash-name branch can't coexist with a branch at one of its
  # path segments (git stores refs as files). Catch it here with a clear fix
  # instead of git's cryptic "cannot lock ref ... exists" mid-operation.
  if ! branch_exists "$branch"; then
    local clash
    clash="$(df_conflict "$branch" || true)"
    [ -n "$clash" ] && die "cannot create '$branch': it collides with existing branch '$(hl "$clash")' (git refs are file paths, so '$clash' blocks the '$branch' hierarchy).
  fix: delete the blocker  ->  git branch -D $clash  (and: git branch -dr origin/$clash)
  or:  use a non-slash name ->  $0 add ${branch//\//-} $path"
  fi

  # Fetch only the branch we need (or the base to fork from), not all of
  # origin/* — a plain `git fetch` on a big monorepo pulls 100k+ objects.
  # Best-effort: if it fails (e.g. a stale lock from a case-collision branch),
  # warn and proceed using whatever refs we already have locally.
  local fetch_ref="$branch"
  remote_branch_exists "$branch" || fetch_ref="${base:-$(default_branch)}"
  info "fetching origin/$fetch_ref"
  if ! fetch_one "$fetch_ref"; then
    if clean_stale_locks && fetch_one "$fetch_ref"; then
      info "fetched after clearing stale locks"
    else
      warn "fetch failed; proceeding with local refs (run '$0 doctor' to diagnose)"
    fi
  fi

  if branch_exists "$branch"; then
    git worktree add "$path" "$branch" >&2
  elif remote_branch_exists "$branch"; then
    git worktree add --track -b "$branch" "$path" "origin/$branch" >&2
  else
    local from="${base:-origin/$(default_branch)}"
    info "creating new branch '$branch' from '$from'"
    git worktree add -b "$branch" "$path" "$from" >&2
  fi

  success "Worktree for $(hl "$branch") created at $(hl "$path")"
}

cmd_rm() {
  [ $# -ge 1 ] || die "usage: rm <path>"
  local path="$1" branch
  [ -d "$path" ] || die "no worktree at $path"
  path="$(cd "$path" && pwd)"
  branch="$(branch_in_worktree "$path" || true)"

  git worktree remove "$path" >&2 || {
    warn "worktree has changes; retrying with --force"
    git worktree remove --force "$path" >&2
  }

  if [ -n "$branch" ] && branch_exists "$branch"; then
    if git branch --merged | grep -qE "^\s*${branch}\$"; then
      git branch -d "$branch" >&2
      success "Worktree at $(hl "$path") removed (branch $(hl "$branch") deleted, was merged)"
    else
      info "kept branch '$branch' (not merged); delete with: git branch -D $branch"
      success "Worktree at $(hl "$path") removed (branch $(hl "$branch") kept)"
    fi
  else
    success "Worktree at $(hl "$path") removed"
  fi
}

cmd_ls() { git worktree list; }

# Interactively pick a worktree with fzf and print its path to STDOUT.
# Because a script runs in a subprocess it cannot cd the parent shell, so the
# selected path is printed to stdout (all other output goes to stderr). Use it
# from your shell as:
#   cd "$(git-worktree.sh switch-worktree)"
# Or wrap it in a shell function:
#   wt() { local d; d="$(git-worktree.sh switch-worktree "$@")" && cd "$d"; }
cmd_switch() {
  command -v fzf >/dev/null 2>&1 || die "switch-worktree requires fzf"

  # Tab-separated "<abspath>\t<branch>" for every worktree.
  local list
  list="$(git worktree list --porcelain | awk '
    /^worktree /{ p=$2 }
    /^branch /{ b=$2; sub("refs/heads/","",b); print p "\t" b }
    /^detached/{ print p "\t(detached)" }
  ')"
  [ -n "$list" ] || die "no worktrees found"

  local target
  if [ $# -gt 0 ]; then
    # Non-interactive: first worktree whose path or branch matches the query.
    target="$(printf '%s\n' "$list" | grep -i -- "$*" | head -1 | cut -f1)"
    [ -n "$target" ] || die "no worktree matching '$*'"
  else
    # Interactive. Display "branch    relpath" (relative to the common parent
    # of all worktrees) but keep the absolute path as a hidden trailing field
    # so we can cd to it. fzf shows only the first field; we return the last.
    target="$(printf '%s\n' "$list" | awk -F'\t' '
      { paths[NR]=$1; branch[NR]=$2; n=NR }
      END {
        # Longest common character prefix of all worktree paths.
        pfx=paths[1]
        for (i=2; i<=n; i++) {
          while (substr(paths[i],1,length(pfx)) != pfx) pfx=substr(pfx,1,length(pfx)-1)
        }
        sub(/[^\/]*$/,"",pfx)            # trim back to last "/"
        for (i=1; i<=n; i++) {
          rel=paths[i]; sub("^" pfx, "", rel)
          # field 1 = display "<relpath> (<branch>)", field 2 = hidden abspath
          printf "%s (%s)\t%s\n", rel, branch[i], paths[i]
        }
      }' |
      fzf --prompt='worktree> ' --height=40% --reverse \
          --delimiter='\t' --with-nth=1 |
      awk -F'\t' '{ print $2 }')"
    [ -n "$target" ] || exit 0 # cancelled
  fi

  # The path is the *only* thing on stdout, so `cd "$(...)"` works.
  printf '%s\n' "$target"
}

cmd_refresh() {
  [ $# -ge 2 ] || die "usage: refresh <branch> <path> [--merge <other-branch>] [--force]"
  local branch="$1" path="$2"
  shift 2
  local merge_from="" force=0
  while [ $# -gt 0 ]; do
    case "$1" in
    --merge)
      merge_from="${2:-}"
      [ -n "$merge_from" ] || die "--merge needs a branch"
      shift 2
      ;;
    --force | -f)
      force=1
      shift
      ;;
    *) die "unknown flag: $1" ;;
    esac
  done

  # Normalize <path> to an absolute path when it already exists, so we can
  # reliably compare it against the (always-absolute) worktree-holder path.
  local abspath="$path"
  [ -d "$path" ] && abspath="$(cd "$path" && pwd)"
  local holder
  holder="$(worktree_holding_branch "$branch")"

  # 1. Fetch latest from origin *first*, so the safety checks below compare
  #    against the current origin. Targeted single-branch fetch (not all of
  #    origin/*) to avoid pulling 100k+ objects on a big monorepo. The
  #    leading '+' force-updates refs/remotes/origin/<branch>, which also
  #    clears a stale ref that would otherwise block the update.
  info "fetching origin/$branch"
  if ! fetch_one "$branch"; then
    clean_stale_locks && fetch_one "$branch" || die "fetch failed; run: $0 doctor"
  fi
  remote_branch_exists "$branch" || die "origin/$branch does not exist"

  # 2. Safety checks — refresh is destructive (it discards the working tree
  #    and force-resets the branch ref). Unless --force is given, refuse to
  #    clobber uncommitted changes or unpushed commits.
  if [ "$force" -eq 0 ]; then
    if [ -d "$abspath" ] && worktree_is_dirty "$abspath"; then
      die "worktree at $abspath has uncommitted changes; commit/stash them or pass --force"
    fi
    if [ -n "$holder" ] && [ "$holder" != "$abspath" ] && worktree_is_dirty "$holder"; then
      die "worktree at $holder (holds $branch) has uncommitted changes; commit/stash them or pass --force"
    fi
    if branch_exists "$branch"; then
      local ahead
      ahead="$(git rev-list --count "origin/$branch..$branch" 2>/dev/null || echo 0)"
      [ "$ahead" -eq 0 ] ||
        die "$branch has $ahead commit(s) not on origin/$branch; push them or pass --force to discard"
    fi
  fi

  # 3. Drop any existing worktree at <path>, and any other worktree that
  #    happens to hold <branch> checked out (so we can reset the ref freely).
  if [ -d "$abspath" ]; then
    info "removing existing worktree: $abspath"
    git worktree remove --force "$abspath" >&2 || die "could not remove $abspath"
  fi
  if [ -n "$holder" ] && [ "$holder" != "$abspath" ]; then
    info "branch '$branch' is checked out at $holder; removing that worktree"
    git worktree remove --force "$holder" >&2 || die "could not remove $holder"
  fi

  # 4. Force-update the local branch ref. Safe because we just removed every
  #    worktree that had it checked out.
  if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git update-ref "refs/heads/$branch" "refs/remotes/origin/$branch" >&2
  else
    warn "no refs/remotes/origin/$branch (likely a D/F conflict); using FETCH_HEAD"
    git fetch origin "+refs/heads/$branch:refs/heads/$branch" >&2
  fi

  # 5. Create a fresh worktree at <path>.
  info "creating worktree at $path from $branch"
  git worktree add "$path" "$branch" >&2
  if ! git -C "$path" branch --set-upstream-to="origin/$branch" "$branch" 2>/dev/null; then
    if [ -z "$(git config --get-all remote.origin.fetch)" ]; then
      warn "could not set upstream: remote.origin.fetch is empty; fix with:"
      warn "  git config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'"
      warn "  git fetch --prune origin"
    else
      warn "could not set upstream to origin/$branch (skipping)"
    fi
  fi

  # 6. Optional merge.
  if [ -n "$merge_from" ]; then
    info "merging '$merge_from' into '$branch' at $path"
    git -C "$path" merge --no-edit "$merge_from" >&2 ||
      die "merge of '$merge_from' had conflicts; resolve in $path"
    success "Worktree refreshed at $(hl "$path") — $(hl "$branch") reset to origin and $(hl "$merge_from") merged in"
  else
    success "Worktree refreshed at $(hl "$path") — $(hl "$branch") reset to origin/$branch"
  fi
}

cmd_clean() {
  git worktree prune >&2
  git worktree list
}

cmd_doctor() {
  local common_dir
  common_dir="$(cd "$(git rev-parse --git-common-dir)" && pwd)"
  local issues=0
  local fix_cmds=()

  info "scanning $common_dir"

  # 1. Stale .lock files under refs/.
  local locks
  locks="$(find "$common_dir/refs" -name '*.lock' 2>/dev/null || true)"
  if [ -n "$locks" ]; then
    issues=$((issues + 1))
    warn "stale ref lock files found:"
    while IFS= read -r f; do printf '    %s\n' "$f" >&2; done <<<"$locks"
    fix_cmds+=("find \"\$(git rev-parse --git-common-dir)/refs\" -name '*.lock' -delete")
  fi

  # 2. Case-collision branches. Catches both loose refs (refs/heads/<name>)
  #    and packed refs (entries in packed-refs).
  local all_branches collisions
  all_branches="$(
    {
      git for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null
      git for-each-ref --format='%(refname:short)' refs/remotes/origin/ 2>/dev/null
    } |
      sort -u
  )"
  collisions="$(printf '%s\n' "$all_branches" | awk '{
    lc=tolower($0); if (seen[lc]++) print lc; else map[lc]=$0
  } END {
    for (k in seen) if (seen[k] > 1) print k
  }' | sort -u)"
  if [ -n "$collisions" ]; then
    issues=$((issues + 1))
    warn "case-collision branches (problematic on macOS case-insensitive FS):"
    while IFS= read -r lc; do
      [ -z "$lc" ] && continue
      printf '    %s — variants:\n' "$lc" >&2
      printf '%s\n' "$all_branches" | awk -v lc="$lc" 'tolower($0)==lc{print "      "$0}' >&2
    done <<<"$collisions"
    warn "delete the variant(s) you don't need with: git branch -D <name>"
  fi

  # 3. Directory/file (D/F) ref conflicts. A branch "a" blocks the whole
  #    "a/*" hierarchy because git stores refs as file paths. Lists each
  #    blocker branch alongside the slash-names it would prevent.
  local df_blockers
  df_blockers="$(printf '%s\n' "$all_branches" | awk '
    { b[NR]=$0; n=NR }
    END {
      for (i=1; i<=n; i++) for (j=1; j<=n; j++)
        if (i!=j && index(b[j], b[i] "/") == 1) { print b[i]; break }
    }' | sort -u)"
  if [ -n "$df_blockers" ]; then
    issues=$((issues + 1))
    warn "directory/file ref conflicts (a branch that blocks a slash-name hierarchy):"
    while IFS= read -r blk; do
      [ -z "$blk" ] && continue
      printf '    %s — blocks:\n' "$blk" >&2
      printf '%s\n' "$all_branches" | awk -v p="$blk/" 'index($0,p)==1{print "      "$0}' >&2
      fix_cmds+=("git branch -D $blk   # then re-create the $blk/* worktree")
    done <<<"$df_blockers"
  fi

  # 4. Empty remote.origin.fetch refspec.
  if [ -z "$(git config --get-all remote.origin.fetch 2>/dev/null)" ]; then
    issues=$((issues + 1))
    warn "remote.origin.fetch is empty — git branch --set-upstream-to will fail"
    fix_cmds+=("git config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'")
    fix_cmds+=("git fetch --prune origin")
  fi

  # 5. Orphaned worktree entries (worktree dir is gone but git still tracks it).
  local stale_wts
  stale_wts="$(git worktree list --porcelain | awk '
    /^worktree /{p=$2} /^prunable /{print p}
  ')"
  if [ -n "$stale_wts" ]; then
    issues=$((issues + 1))
    warn "prunable worktree entries:"
    while IFS= read -r p; do printf '    %s\n' "$p" >&2; done <<<"$stale_wts"
    fix_cmds+=("git worktree prune")
  fi

  if [ "$issues" -eq 0 ]; then
    success "No issues found."
    return 0
  fi

  if [ ${#fix_cmds[@]} -gt 0 ]; then
    printf '\n%ssuggested fixes (run in order):%s\n' "$C_BOLD" "$C_RESET" >&2
    for c in "${fix_cmds[@]}"; do printf '  %s\n' "$c" >&2; done
  fi
  warn "found $issues issue(s); re-run doctor after applying fixes"
}

usage() {
  cat <<'EOF'
git-worktree.sh — seamless git worktree management

All paths are explicit; this script makes no assumption about where your
worktrees live. All commands work from anywhere inside the main repo or
any of its worktrees.

Usage:
  git-worktree.sh add <branch> <path> [base-ref]
      Create a worktree at <path> for <branch>. If <branch> exists locally
      it is checked out; else if origin/<branch> exists it is tracked;
      else a new branch is created from [base-ref] (or origin/HEAD).

  git-worktree.sh rm <path>
      Remove the worktree at <path>. Also deletes the branch if merged.

  git-worktree.sh ls
      List worktrees.

  git-worktree.sh switch-worktree [query]   (aliases: switch, sw)
      Pick a worktree with fzf and print its path to stdout. Since a script
      cannot cd the parent shell, use it as:
          cd "$(git-worktree.sh switch-worktree)"
      or wrap it in a shell function:
          wt() { local d; d="$(git-worktree.sh switch-worktree "$@")" && cd "$d"; }
      With [query], skips fzf and prints the first worktree whose path or
      branch matches.

  git-worktree.sh refresh <branch> <path> [--merge <other>] [--force]
      Wipe any existing worktree at <path> (and any worktree currently
      holding <branch>), force-reset local <branch> to origin/<branch>,
      and create a fresh worktree at <path>. With --merge, merge <other>
      into the freshly-reset branch. Use this for weekly-reset upstreams
      (e.g. channel/beta) to avoid rebase/conflict churn.

      Refuses to run if the target worktree has uncommitted changes or if
      <branch> has commits not on origin/<branch>. Pass --force to discard
      them anyway.

  git-worktree.sh clean
      Prune stale worktree entries.

  git-worktree.sh doctor
      Diagnose common worktree/fetch issues that cause "cannot lock ref"
      or "is not a branch" failures. Reports findings and the exact fix
      commands — does not modify anything on its own. Checks:
        - stale .lock files under refs/
        - case-collision branches (macOS case-insensitive FS)
        - empty remote.origin.fetch refspec
        - orphaned worktree entries
EOF
}

main() {
  [ $# -ge 1 ] || {
    usage >&2
    exit 1
  }

  local sub="$1"
  shift

  case "$sub" in
  add) cmd_add "$@" ;;
  rm | remove) cmd_rm "$@" ;;
  ls | list) cmd_ls "$@" ;;
  switch-worktree | switch | sw) cmd_switch "$@" ;;
  refresh) cmd_refresh "$@" ;;
  clean | prune) cmd_clean "$@" ;;
  doctor) cmd_doctor "$@" ;;
  -h | --help | help) usage ;;
  *) die "unknown subcommand: $sub" ;;
  esac
}

main "$@"
