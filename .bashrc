# .bashrc
# avoid anything in this file from breaking ssh
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi
#---------------------------------------------------------------------------------------------------------------------
#Source my aliases and functions
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
#---------------------------------------------------------------------------------------------------------------------
#No duplicates + no empty space starting cmds in Bash History
export HISTCONTROL=ignoreboth
#Increase bash history size to be 130K and unlimited file size !
HISTSIZE=130000
HISTFILESIZE=-1

#Remember bash history across sessions
#(http://briancarper.net/blog/248.html)
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"

#Use VI key bindings
#set -o vi
#set editing-mode vi

# User specific aliases and functions for all shells
export EDITOR=vim
export VISUAL=vim
add_path "${HOME}/devtools/"

#Set PS1 to have exit code, user@hostname and full path
export PS1='${debian_chroot:+($debian_chroot)}[\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\
\
\]\W {$?}]\$\[\033[00m\] '

#With this less file.zip will show contents of zip in paginated less reader
export LESSOPEN="|/usr/bin/lesspipe.sh %s"

#Use Fuzzy bash history extension (https://github.com/junegunn/fzf)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#---------------------------------------------------------------------------------------------------------------------
