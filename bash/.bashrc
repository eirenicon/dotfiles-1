#! /bin/bash
# ~/.bashrc: executed by bash(1) for interactive shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="[%F | %R] "
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

# https://twitter.com/michaelhoffman/status/639178145673932800
HISTFILE="${HOME}/.history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# tmux expects screen-256color, doesn't seem to affect anything else
export TERM=xterm-256color

[ -f ~/.bash_env ] && source ~/.bash_env

[ -f /etc/profile.d/autojump.bash ] && source /etc/profile.d/autojump.bash

if [ -f ~/.bash_prompt ]; then
    source ~/.bash_prompt
else
    export PS1='\[\e[0;34m\]\u\[\e[0;37m\] @ \[\e[0;35m\]\h\[\em\]\[\e[0;37m\]: \[\e[1;34m\]\w\[\e[m\] \[\e[0;37m\]\n\$\[\e[m\] \[\e[1;37m\]'
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
