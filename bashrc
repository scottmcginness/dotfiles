# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

prompt_logos=yes
function prompt_logo {
    logo=""
    if [[ $prompt_logos = yes ]]; then
        case "$1" in
            git)  logo="⏧ ";;
            hg)   logo="🜐 ";;
            rvm)  logo="💎 ";;
            venv) logo="🐍 ";;
        esac
    fi
    echo "$logo"
}

# enable tab completion in git
source ~/.git-completion.bash

# Enable tab completion for Fabric
source ~/.fab-completion.sh

# using git status for the prompt
# can currently only be used in colour mode
# uncomment to disable
use_git_prompt=yes

# print '*' to prompt when git status has changed
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

# print current branch (with dirty status) to prompt
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/($(prompt_logo 'git')\1$(parse_git_dirty))/"
}

function parse_hg_dirty {
 [[ $(hg status 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

function parse_hg_branch {
hg branch 2> /dev/null | sed -e "s/\(.*\)/($(prompt_logo 'hg')\1$(parse_hg_dirty))/"
}

function parse_virtualenv {
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "($(prompt_logo 'venv')$(basename "$VIRTUAL_ENV"))"
    else
        echo ""
    fi
}

show_gemset=no
function parse_rvm_gemset {
if [[ "$show_gemset" = yes ]]; then
rvm gemset list 2> /dev/null | grep "=>" | sed -e "s/^=> (\?\([^)]*\))\?/($(prompt_logo 'rvm')\1)/"
fi
}

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function color {
    echo -ne "\[\033[38;5;$1m\]"
}
function nocolor {
    echo -ne "\[\033[0m\]"
}
if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}$(color 22)\u@\h$(nocolor):$(color 25)\w$(color 131)"'$(parse_virtualenv)$(parse_git_branch)$(parse_hg_branch)$(parse_rvm_gemset)'"\n$(color 22)\$$(nocolor) "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --hide=*.pyc'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).

if [ -n "$BASH_VERSION" -a -n "$PS1" -a -z "$BASH_COMPLETION" ]  &&
   [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export PYTHONSTARTUP="$HOME/.pythonrc"
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sandbox/Projects
export PIP_DOWNLOAD_CACHE=$WORKON_HOME/.pip-cache
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PIP_RESPECT_VIRTUALENV=true
source /usr/local/bin/virtualenvwrapper.sh

if [ -f "$WORKON_HOME/django_bash_completion" ]; then
    . $WORKON_HOME/django_bash_completion
fi

# Tell NuGet that it can package restore
# See http://blog.ianbattersby.com/2012/08/04/using-nuget-with-mono/
export EnableNuGetPackageRestore=true
