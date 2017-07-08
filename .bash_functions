# Some of below useful functions are taken from
#https://github.com/cep21/jackbash/blob/master/bashrc
#-------------------------------------------------
#Example: add_path "/new_path"
function add_path()     { export PATH="$PATH:$1"; }
function add_pre_path() { export PATH="$1:$PATH"; }
#-------------------------------------------------
#Change directory and do ls -a
function cl(){ cd "$@" && la; }
#-------------------------------------------------
# Repeat a command N times. Example: repeat 3 echo 'hi'
function repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}
#-------------------------------------------------
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
#-------------------------------------------------
# Extract based upon file ext
function ex() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"        ;;
            *.tar.gz)    tar xvzf "$1"        ;;
            *.tar.xz)    tar xvJf "$1"        ;;
            *.bz2)       bunzip2 "$1"         ;;
            *.rar)       unrar x "$1"         ;;
            *.gz)        gunzip "$1"          ;;
            *.tar)       tar xvf "$1"         ;;
            *.tbz2)      tar xvjf "$1"        ;;
            *.tgz)       tar xvzf "$1"        ;;
            *.jar)       jar xf "$1"          ;;
            *.zip)       unzip "$1"           ;;
            *.Z)         uncompress "$1"      ;;
            *.7z)        7z x "$1"            ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
#-------------------------------------------------
#Compress with tar + bzip2
function bz2() {
    tar cvpjf "$1.tar.bz2" "$1"
}
#-------------------------------------------------
#Check if we can SSH to a HOST with cur credentials
#Usage can_connect_ssh <hostname>
function can_connect_ssh()
{
    SSH_HOST=$1
    ssh -q -o ConnectTimeout=5 -o BatchMode=yes \
        $SSH_HOST echo conn_success       |     \
        grep conn_success &> /dev/null
}
#Use objcopy and SCP to move an object file
#Usage objcopy_scp <LOCAL_FILE> <REMOTE_FILE>
function objcopy_scp()
{
    SRC_PATH=$1
    DST_PATH=$2
    SRC_FILE=$(basename $SRC_PATH)
    if [ -f "${SRC_PATH}" ]
    then
        objcopy $SRC_PATH /tmp/${SRC_FILE}
        scp /tmp/${SRC_FILE} ${DST_PATH}
        rm /tmp/${SRC_FILE}
        return 0
    else
        echo "Invalid local source path"
        return -1
    fi
}
#-------------------------------------------------
