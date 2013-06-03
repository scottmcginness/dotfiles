# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate or blank lines in the history, and
# append to the history file, don't overwrite it
HISTCONTROL=ignoreboth
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt colors
theme_host=88
theme_jobs=160
theme_dir=131
theme_env=203

# Prompt settings
use_prompt_logo=yes  # use logos in the prompt
use_prompt_rvm=no  # show current gemset in the prompt

function prompt_logo {
    logo=""
    if [[ $use_prompt_logo = yes ]]; then
        case "$1" in
            git)  logo="⏧ ";;
            hg)   logo="🜐 ";;
            rvm)  logo="💎 ";;
            venv) logo="🐍 ";;
        esac
    fi
    echo "$logo"
}

# Print '*' to prompt when git status has changed
function parse_git_dirty {
[[ ! $(git status 2> /dev/null | tail -n1) =~ ^nothing\ to\ commit(,\ |\ \()working\ directory\ clean\)?$ ]] && echo "*"
}

# Print current git branch (with dirty status) to prompt
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/($(prompt_logo 'git')\1$(parse_git_dirty))/"
}

# Print '*' to prompt when hg status has changed
function parse_hg_dirty {
 [[ $(hg status 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

# Print current hg branch (with dirty status) to prompt
function parse_hg_branch {
hg branch 2> /dev/null | sed -e "s/\(.*\)/($(prompt_logo 'hg')\1$(parse_hg_dirty))/"
}

# Print active virtualenv to prompt
function parse_virtualenv {
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "($(prompt_logo 'venv')$(basename "$VIRTUAL_ENV"))"
    else
        echo ""
    fi
}

# Print active gemset to prompt
function parse_rvm_gemset {
if [[ "$use_prompt_rvm" = yes ]]; then
    rvm gemset list 2> /dev/null | grep "=>" | sed -e "s/^=> (\?\([^)]*\))\?/($(prompt_logo 'rvm')\1)/"
fi
}

# Print numbers of jobs to prompt
function parse_jobs {
    jobs | sed -e 's/\[\([0-9]\+\)\]\([+-]\)\?.*/\1\2/' | tr '\n' ',' | sed -e 's/^\(.*\),$/[\1]/'
}

# Print a 256-color for prompt
function color {
    echo -ne "\[\033[38;5;$1m\]"
}

# Stop color prompt
function nocolor {
    echo -ne "\[\033[0m\]"
}

# The prompt
PS1="${debian_chroot:+($debian_chroot)}$(color $theme_host)\u@\h$(color $theme_jobs)"'$(parse_jobs)'"$(color $theme_host):$(color $theme_dir)\w$(color $theme_env)"'$(parse_virtualenv)$(parse_git_branch)$(parse_hg_branch)$(parse_rvm_gemset)'"\n$(color $theme_host)\$$(nocolor) "


# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -n "$BASH_VERSION" -a -n "$PS1" -a -z "$BASH_COMPLETION" ]  &&
   [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Enable tab completion in git, Fabric and Django
source ~/.git-completion.bash
source ~/.fab-completion.sh
if [ -f "$WORKON_HOME/django_bash_completion" ]; then
    . $WORKON_HOME/django_bash_completion
fi

# Python, virtualenv and pip settings
export PYTHONSTARTUP="$HOME/.pythonrc"
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sandbox/Projects
export PIP_DOWNLOAD_CACHE=$WORKON_HOME/.pip-cache
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PIP_RESPECT_VIRTUALENV=true
source /usr/local/bin/virtualenvwrapper.sh

# Tell NuGet that it can package restore
# See http://blog.ianbattersby.com/2012/08/04/using-nuget-with-mono/
export EnableNuGetPackageRestore=true
