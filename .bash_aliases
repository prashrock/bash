#move-back 'x' levels
alias  ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

#Set trigger in iTerm to bounce icon when 007 is printed
alias beep="echo -ne '\007'"

#Alias for ls (with more color and less \n)
alias less='less -s'
if ls --color $HOME >&/dev/null; then
    alias ls='ls --color -G'
fi
alias ll='ls -l'
alias la='ls -la'

alias meminfo='watch -n 1 cat /proc/meminfo'
alias emacs='emacs -nw'
alias diff="diff -Bdwbu"

#-------------------------------------------------
#-------------------------------------------------
#
#Customized egrep (e.g. egcpp "\WSomething")
alias egcpp='find . -name "*.cpp" -o -name "*.c" -o -name "*.h" | xargs egrep -n --color'
#-------------------------------------------------
#-------------------------------------------------
