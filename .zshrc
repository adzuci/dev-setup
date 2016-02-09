# My .zshrc file
#
# Written by Matthew Blissett & Adam Blackwell
#
# Latest version of Mathew's available from
# <http://matt.blissett.me.uk/linux/zsh/zshrc>
#
# Some functions taken from various web sites/mailing lists, others written
# myself.
#
# Last updated February 2016

# ZSH Settings
ZSH_THEME="agnoster"

plugins=(fasd complist git ruby sublime docker)

export ZSH=$HOME/.oh-my-zsh
export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
source $ZSH/oh-my-zsh.sh

autoload -U bashcompinit
bashcompinit

alias rc='vi ~/.zshrc'



# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=99000
export HISTFILE=~/.zsh_history
export SAVEHIST=99000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey \^U backward-kill-line

# Zsh spelling correction options
setopt CORRECT
#setopt DVORAK

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors` ]]; then
  eval `dircolors -b`
  alias 'ls=ls --color=auto'
    fi
fi

## Quantopian Specific
export CODE=$HOME/Documents/code
export PATH=$CODE/orchestration/credentials_database/bin:$PATH
source $CODE/orchestration/credentials_database/etc/bash_completion
alias code='cd $CODE'

# AWS
awsenv ()
{
  environment=$1;
  if [[ -z $environment ]]; then
    env | grep --color=auto AWS;
  else
    if [[ $environment == 'clear' ]]; then
      unset AWS_PROFILE;
      unset AWS_DEFAULT_PROFILE;
    else
      export AWS_PROFILE=$environment;
      export AWS_DEFAULT_PROFILE=$environment;
      env | grep --color=auto AWS;
    fi;
  fi
}

function quantoec2(){
    if [[ -z $1 && -z $2 ]]; then
        echo "Usage: quantoec2 <environment(development|staging|production)> <group/tag(cassandra|elasticsearch|tag_Name_Foo)> [command]";
    else
        if [[ -z $3 ]]; then
            ansible -i ${CODE}/orchestration/ansible/environments/${1} ${2} --list-hosts;
        else
            ansible -i ${CODE}/orchestration/ansible/environments/${1} ${2} -m shell -a "${3}";
        fi;
    fi
}

# Git
alias git=hub

# Papertrail
alias pt='papertrail'
export PAPERTRAIL_API_TOKEN=

# Google
export GOPATH=/Users/adzuci/Documents/gocode

# Brew:
#export HOMEBREW_GITHUB_API_TOKEN=

# OSX Specific
ulimit -n 4096
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Docker
docker-ip() {
  boot2docker ip 2> /dev/null
}
eval "$(docker-machine env dev)"

# Python Specific
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

function print-lines(){
    trap 'echo "# $BASH_COMMAND"' DEBUG
}

function venv-clear()
{
  (
   print-lines;
   local previous=`basename $VIRTUAL_ENV`
   deactivate;
   rmvirtualenv $previous;
   mkvirtualenv $previous "$@";
   workon $previous;
  )
}

source /usr/local/bin/virtualenvwrapper.sh
alias v='workon'
alias v.deactivate='deactivate'
alias v.mk='mkvirtualenv'
alias v.rm='rmvirtualenv'
alias v.switch='workon'
alias v.add2virtualenv='add2virtualenv'
alias v.cdsitepackages='cdsitepackages'
alias v.cd='cdvirtualenv'
alias v.lssitepackages='lssitepackages'

# Ruby
source ~/.profile
# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Original:

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Set less options
if [[ -x $(which less) ]]
then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    if [[ -x $(which lesspipe.sh) ]]
    then
  LESSOPEN="| lesspipe.sh %s"
  export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which vim) ]]
then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Short command aliases
alias 'l=ls'
alias 'la=ls -Ahl | less'
alias 'll=ls -l'
alias 'lq=ls -Q'
alias 'lr=ls -R'
alias 'lrs=ls -lrS'
alias 'lrt=ls -lrt'
alias 'lrta=ls -lrtA'
alias 'j=jobs -l'
alias 'kw=kwrite'
alias 'tf=tail -f'
alias 'grep=grep --colour'
alias 'e=emacs -nw --quick'
alias 'vi=vim'
alias 'sx=screen -x'
alias 'sr=screen -rD'
alias 'sl=screen -ls'

# Useful KDE integration (see later for definition of z)
alias 'k=z kate -u' # -u is reuse existing session if possible
alias 'q=z kfmclient openURL' # Opens (or executes a .desktop) arg1 in Konqueror

# These are useful with the Dvorak keyboard layout
alias 'h=ls'
alias 'ha=la'
alias 'hh=ll'
alias 'hq=lq'
alias 'hr=lr'
alias 'hrt=lrt'
alias 'hrs=lrs'

# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# For convenience
alias 'mkdir=mkdir -p'
alias 'dus=du -H -msh * | sort -n'
alias "cmds=history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head"
alias 'ports=netstat -tlnp'
alias "tof=watch --differences -n 5 'df; ls -FlAt;'"
alias 'myip=python -c "import socket; print '\n'.join(socket.gethostbyname_ex(socket.gethostname())[2])"'

# Typing errors...
alias 'cd..=cd ..'

# Running 'b.ps' runs 'q b.ps'
alias -s ps=q
alias -s html=q

# PDF viewer (just type 'file.pdf')
if [[ -x `which kpdf` ]]; then
    alias -s 'pdf=kfmclient exec'
else
    if [[ -x `which gpdf` ]]; then
  alias -s 'pdf=gpdf'
    else
  if [[ -x `which evince` ]]; then
  		alias -s 'pdf=evince'
  fi
    fi
fi

# Global aliases (expand whatever their position)
#  e.g. find . E L
alias -g L='| less'
alias -g H='| head'
alias -g S='| sort'
alias -g T='| tail'
alias -g N='> /dev/null'
alias -g E='2> /dev/null'

# Automatically background processes (no output to terminal etc)
alias 'z=echo $RANDOM > /dev/null; zz'
zz () {
    echo $*
    $* &> "/tmp/z-$1-$RANDOM" &!
}

# Aliases to use this
# Use e.g. 'command gv' to avoid
alias 'acroread=z acroread'
alias 'amarok=z amarok'
alias 'azureus=z azureus'
alias 'easytag=z easytag'
alias 'eclipse=z eclipse'
alias 'firefox=z firefox'
alias 'icedove=z icedove'
alias 'gaim=z gaim'
alias 'gimp=z gimp'
alias 'gpdf=z gpdf'
alias 'gv=z gv'
alias 'k3b=z k3b'
alias 'kate=z kate'
alias 'kmail=z kmail'
alias 'konqueror=z konqueror'
alias 'konsole=z konsole'
alias 'kontact=z kontact'
alias 'kopete=z kopete'
alias 'kpdf=z kpdf'
alias 'kwrite=z kwrite'
alias 'ooffice=z ooffice'
alias 'oowriter=z oowriter'
alias 'opera=z opera'
alias 'pan=z pan'
alias 'sunbird=z sunbird'
alias 'thunderbird=z thunderbird'

# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

# Remap Dvorak-Qwerty quickly
alias 'aoeu=setxkbmap gb' # (British keyboard layout)
alias 'asdf=setxkbmap gb dvorak 2> /dev/null || setxkbmap dvorak gb 2> /dev/null || setxkbmap dvorak'

# Clear konsole history
alias 'zaph=dcop $KONSOLE_DCOP_SESSION clearHistory'

# When directory is changed set xterm title to host:dir
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
  sun-cmd) print -Pn "\e]l%~\e\\";;
        *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%m:%~\a";;
    esac
}

# For changing the umask automatically
# Maybe I should be using chpwd for this.
umask 0077
cd() {
    builtin cd $*

    # Private folders
    if [[ -z ${~PWD:#${HOME}}            ]] then
        if [[ $(umask) -ne 077 ]] then
            umask 0077
            echo -e "\033[01;32mUmask: private \033[m"
  			fi
    fi
    # Public folders
    if [[ -z ${~PWD:#/.www*}       ||
          -z ${~PWD:#${HOME}/www*} ]] then
        if [[ $(umask) -ne 072 ]] then
            umask 0072
            echo -e "\033[01;33mUmask: other readable \033[m"
        fi
    fi
}

cd . &> /dev/null

# For quickly plotting data with gnuplot.  Arguments are files for 'plot "<file>" with lines'.
plot () {
    echo -n '(echo set term png; '
    echo -n 'echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot | display png:-'

    (
  echo "set term png"
  echo -n plot \"$1\" with lines
  for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
  ) | gnuplot | display png:-
}

# Persistant gnuplot (can be resized etc)
plotp () {
    echo -n '(echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot -persist'

    (
  echo -n plot \"$1\" with lines
  for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
  echo
  ) | gnuplot -persist
}

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _match
zstyle ':completion:*' completions 0
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle -d users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
    named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys  www-data \
    avahi Debian-exim hplip list cupsys haldaemon ntpd proftpd statd

# zstyle ':completion:*' hosts $(<$HOME/.hosts)

zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zstyle ':completion:*:*:xdvi:*' file-sort time

autoload zsh/sched

# Copys word from earlier in the current command line
# or previous line if it was chosen with ^[. etc
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

# Cycle between positions for ambigous completions
autoload cycle-completion-positions
zle -N cycle-completion-positions
bindkey '^[z' cycle-completion-positions

# Increment integer argument
autoload incarg
zle -N incarg
bindkey '^X+' incarg

# Write globbed files into command line
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files

# Play tetris
autoload -U tetris
zle -N tetris
bindkey '^X^T' tetris

# xargs but zargs
autoload -U zargs

# Calculator
autoload zcalc

# Line editor
autoload zed

# Renaming with globbing
autoload zmv

# Various reminders of things I forget...
# (Mostly useful features that I forget to use)
# vared
# =ls turns to /bin/ls
# =(ls) turns to filename (which contains output of ls)
# <(ls) turns to named pipe
# ^X* expand word
# ^[^_ copy prev word
# ^[A accept and hold
# echo $name:r not-extension
# echo $name:e extension
# echo $xx:l lowercase
# echo $name:s/foo/bar/
