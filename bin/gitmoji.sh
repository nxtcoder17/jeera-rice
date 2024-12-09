emojis=$(
  cat <<EOF
🎉	:tada:	Initial commit
🔖	:bookmark:	Version tag
✨	:sparkles:	New feature
🐛	:bug:	Bugfix
📇	:card_index:	Metadata
📚	:books:	Documentation
💡	:bulb:	Documenting source code
🐎	:racehorse:	Performance
💄	:lipstick:	Cosmetic
🚨	:rotating_light:	Tests
✅	:white_check_mark:	Adding a test
✔️	:heavy_check_mark:	Make a test pass
⚡	:zap:	General update
🎨	:art:	Improve format/structure
🔨	:hammer:	Refactor code
🔥	:fire:	Removing code/files
💚	:green_heart:	Continuous Integration
🔒	:lock:	Security
⬆️	:arrow_up:	Upgrading dependencies
⬇️	:arrow_down:	Downgrading dependencies
👕	:shirt:	Lint
👽	:alien:	Translation
📝	:pencil:	Text
🚑	:ambulance:	Critical hotfix
🚀	:rocket:	Deploying stuff
🍎	:apple:	Fixing on MacOS
🐧	:penguin:	Fixing on Linux
🏁	:checkered_flag:	Fixing on Windows
🚧	:construction:	Work in progress
👷	:construction_worker:	Adding CI build system
EOF
)

selection=$(echo "$emojis" | fzf -d\\t)
[ -z "$selection" ] && exit 0

echo "$selection" | awk -F\\t '{ print $1 }'
