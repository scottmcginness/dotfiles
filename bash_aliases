# Not really an alias, but an easy way to change to a new directory
function cnd() {
	mkdir $1 && cd $1
}
# quick cd to parent and grandparent
alias ..='cd ..'
alias ...='cd ../..'

# Use `ack` instead of `ack-grep`
alias ack='ack-grep'

# Use clipboard
alias clip='xclip -sel clip-board'
