# Better ls and grep
alias ls='ls --color=auto --hide=*.pyc'
alias ll='ls -l'
alias la='ls -Al'
alias grep='grep --color=auto -P'

# Not really an alias, but an easy way to change to a new directory
function cnd() {
	mkdir $1 && cd $1
}

# quick cd to parent and grandparent
alias ..='cd ..'
alias ...='cd ../..'

# Use clipboard
alias clip='xclip -sel clip-board'

# Typo chmox
function chmox() {
    chmod +x $1
}

# Quick github clone
function clone() {
    git clone "https://github.com/"$1".git"
}

# Get unicode codepoint from utf-8
function codepoint() {
    echo -n $1 | uconv -f utf-8 -x 'any-hex' | sed 's/\\u\(.*\)/\1/' | tr '[A-Z]' '[a-z]'
    echo
}

# Quick open
function o() {
    gnome-open $@
}

# Quick pip freeze into requirements
function pipg() {
    pip freeze 2>/dev/null | grep $@
}

# Quick find process
function psg() {
ps -Af | grep -P "(^UID.*|$1)" | head -n-2 | less
}

# No more nano
function nano() {
    echo "Did you mean vim?"
}

# No quit in bash
:q() { echo "This is bash, not vim. Try ‘<Ctrl-d>’ or ‘logout’"; }

# Edit in vim, from bash
:e() {
    read -n1 -p "You probably meant: ‘vim $@’ [Y/n]? " dovim;
    echo
    if [ "$dovim" = "y" -o "$dovim" = "" ]; then
        vim $@
    fi
}

# Install vim bundles
function vundle() {
    vim +BundleInstall! +qa!
}

# Quick python
alias p=ipython

# Quick tmux
alias tm='tmux -2'
