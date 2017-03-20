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
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias diff="diff -Bdwbu"
function cl(){ cd "$@" && la; }
#----------------------------------------------------------------------------------------------------------------------
#Converts '\r\n' to '\n' and adds execute permissions to this file
#@Param - Exactly 1 input argument (filename_with_path).
function windows_to_linux_script_convert()
{
    if [ -z "$1" ];  then
      echo "Error: usage - windows_to_linux_script_convert <file_name_with_path>";
      return; 
    fi
    if [ ! -e "$1" ];  then
      echo "Error: '$1' is not a valid file.";
      return; 
    fi
    echo -n "Converting \r\n to \n for '$1'...",
    awk '{ sub(/\r$/,""); print }' $1 > $1.shtest && mv -f $1.shtest $1
    chmod 755 $1
    echo "Done.",
}
export -f windows_to_linux_script_convert
#Below example shows how to use the above function for multiple files
#find <path> -name "*.sh" -type f -print0 | xargs -0 -n1 -I{} bash -c "windows_to_linux_script_convert {}"
#----------------------------------------------------------------------------------------------------------------------
# Below useful functions are taken from https://github.com/cep21/jackbash/blob/master/bashrc
# Two standard functions to change $PATH. Example: add_path "/new_path"
add_path() { export PATH="$PATH:$1"; }
add_pre_path() { export PATH="$1:$PATH"; }

# Repeat a command N times. Example: repeat 3 echo 'hi'
function repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}

#Simple blowfish encryption
function blow()
{
    [ -z "$1" ] && echo 'Encrypt: blow FILE' && return 1
    openssl bf-cbc -salt -in "$1" -out "$1.bf"
}
function fish()
{
    test -z "$1" -o -z "$2" && echo \
        'Decrypt: fish INFILE OUTFILE' && return 1
    openssl bf-cbc -d -salt -in "$1" -out "$2"
}

# Extract based upon file ext
function ex() {
     if [ -f "$1" ] ; then
         case "$1" in
             *.tar.bz2)   tar xvjf "$1"        ;;
             *.tar.gz)    tar xvzf "$1"     ;;
             *.bz2)       bunzip2 "$1"       ;;
             *.rar)       unrar x "$1"     ;;
             *.gz)        gunzip "$1"     ;;
             *.tar)       tar xvf "$1"        ;;
             *.tbz2)      tar xvjf "$1"      ;;
             *.tgz)       tar xvzf "$1"       ;;
             *.jar)       jar xf "$1"       ;;
             *.zip)       unzip "$1"     ;;
             *.Z)         uncompress "$1"  ;;
             *.7z)        7z x "$1"    ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
# Compress with tar + bzip2
function bz2 () {
  tar cvpjf "$1.tar.bz2" "$1"
}
#----------------------------------------------------------------------------------------------------------------------
