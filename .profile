#This file contains options I find useful in .profile or .bash_profile
#----------------------------------------------------------------------------------------------------------------------
#Useful Bash Properties
set history=2000
set savehist=2000
#----------------------------------------------------------------------------------------------------------------------
#Useful Bash Aliases
alias grep_help='echo grep -nr --include=\*.h \"Hi\" /path 2>/dev/null'
alias find_help='echo find \/path -name \*abc\*'
alias emacs='emacs -nw'
#----------------------------------------------------------------------------------------------------------------------
#Converts '\r\n' to '\n' and adds execute permissions to this file
#@Param - Exactly 1 input argument (filename_with_path).
function windows_to_linux_script_convert()
{
    if [ -z "$1" ];  then
      echo "Error: usage - windows_to_linux_script_convert <file_name_with_path>";
      return; 
    fi
    if [ -e "$1" ];  then
      echo "Error: '$1' is not a valid file.";
      return; 
    fi
    echo -n "Converting \r\n to \n for '$1'...",
    awk '{ sub(/\r$/,""); print }' $1 > $1.shtest && mv -f $1.shtest $1
    chmod 755 $1
    echo "Done.",
}
#----------------------------------------------------------------------------------------------------------------------
