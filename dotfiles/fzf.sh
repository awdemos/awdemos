# Bind Ctrl+f to launch the fuzzy finder menu
bind -x '"\C-f":fzfm'

# Define the fuzzy finder menu function
fzfm() {
	while true; do
		# Generate the selection list using lsd and fzf
		selection="$(
			lsd -a | fzf \
				--reverse \
				--height '95%' \
				--info 'default' \
				--prompt 'Search: ' \
				--border 'rounded' \
				--bind 'left:accept' \
				--bind 'right:accept' \
				--bind 'shift-up:preview-up' \
				--bind 'shift-down:preview-down' \
				--preview-window='right:65%' \
				--preview 'cd_pre=$(pwd)/$(echo {} | sed "s@^/mnt/c@@"); \
                    if [[ -d "$cd_pre" ]]; then \
                        lsd -la --color=always "$cd_pre"; \
                    elif [[ -f "$cd_pre" ]]; then \
                        bat --style=numbers --theme=ansi --color=always "$cd_pre" 2>/dev/null || cat "$cd_pre"; \
                    fi'
		)"

		# Act based on the type of the selected item
		if [[ -n "$selection" ]]; then
			if [[ -d "$selection" ]]; then
				cd "$selection" >/dev/null
			elif [[ -f "$selection" ]]; then
				nvim "$selection"
				break
			fi
		else
			break
		fi
	done
}
