# .bashrc
# avoid anything in this file from breaking ssh
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi

#----------------------------------------------------------------------------------------------------------------------
#Remember bash history across sessions (http://briancarper.net/blog/248.html)
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"
#----------------------------------------------------------------------------------------------------------------------
#Convenient functions and aliases
#Egrep wrapper
#---------------
# customized egrep (add string at the end, e.g. egcpp "\Wwhole_word"
alias egcpp='find . -name "*.cpp" -o -name "*.c" -o -name "*.h" | xargs egrep -n --color'

#Cd and ls
#---------------
function cl(){ cd "$@" && la; }
#----------------------------------------------------------------------------------------------------------------------

