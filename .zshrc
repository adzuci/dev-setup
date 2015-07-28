# My .zshrc file
#
# Written by Matthew Blissett.
#            Adam Blackwell
#
# Latest version available from <http://matt.blissett.me.uk/linux/zsh/zshrc>
#
# Some functions taken from various web sites/mailing lists, others written
# myself.
#
# Last updated September 2014


#source ~/.bin/tmuxinator.zsh
export ZSH=$HOME/.oh-my-zsh

#source /Users/adzuci/.virtualenvs/qops/bin/aws_zsh_completer.sh
#source /usr/local/opt/awscli/libexec/bin/aws_zsh_completer.sh

autoload -U bashcompinit
bashcompinit
#complete -C aws_completer aws


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

plugins=(fasd complist git ruby sublime docker)


source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/Users/adzuci/.local/lib/aws/bin

alias pt='papertrail'
export PAPERTRAIL_API_TOKEN='0gA3YbyIWNwhM9afIeQd'

# Google
export GOPATH=/Users/adzuci/Documents/gocode


# Brew:
export HOMEBREW_GITHUB_API_TOKEN=14ee0ff9a72add8f52d4afbe1f4770c2f797680b

# OSX Specific
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Docker
docker-ip() {
  boot2docker ip 2> /dev/null
}


export DOCKER_TLS_VERIFY=1
export DOCKER_HOST="tcp://boot2docker:2376"
#export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/adzuci/.boot2docker/certs/boot2docker-vm
export RESEARCH_HOSTSETTINGS=/Users/adzuci/Documents/code/research_env/host_settings_research.py

# Python Specific
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
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

syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
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

#Mail
textme(){
   echo "$@" | sendmail 8574921402@messaging.sprintpcs.com
}

# Quantopian Ops Aliases:i
# https://quantopian.atlassian.net/wiki/display/OPS/Shell+functions+for+looking+up+the+instances+in+an+array
ho() {
    dns_servers=$(host -t ns dynoquant.com | awk '{print $NF}')
    for dns_server in $dns_servers; do
    list=$((host -t srv -W 2 _$2._tcp.$1.dynoquant.com $dns_server ||
        host -T -t srv -W 2 _$2._tcp.$1.dynoquant.com $dns_server) |
        awk '/has SRV record/ {print $NF}' | sed 's/\.$//')
    if [ -n "$list" ]; then
        echo "$list"
        return
    fi
    done
}

staging() { ho staging qexec; }
production() { ho production qexec; }
testing() { ho testing qexec; }
lstaging() { ho staging live; }
lproduction() { ho production live; }
ltesting() { ho testing live; }
istaging() { ho staging ibgw; }
iproduction() { ho production ibgw; }
itesting() { ho testing ibgw; }

alias monitor='ssh -i ~/.ssh/id_rsa_adam ec2-user@monitor.quantopian.com'
alias blog='ssh -i ~/.ssh/id_rsa_adam ec2-user@107.20.161.3'
alias smtp='ssh -i ~/.ssh/id_rsa_adam ec2-user@smtprelay.quantopian.com'
alias helen='ssh -i ~/.ssh/id_rsa_adam ec2-user@helen.dynoquant.com'
alias troy='ssh -i ~/.ssh/id_rsa_adam ec2-user@troy.dynoquant.com'

alias code='cd ~/Documents/code'


# rc
alias rc='vi ~/.zshrc'


# Original:

# Skip all this for non-interactive shells
#[[ -z "$PS1" ]] && return

# Set prompt (white and purple, nothing too fancy)
# PS1=$'%{\e[0;37m%}%B%*%b %{\e[0;35m%}%m:%{\e[0;37m%}%~ %(!.#.>) %{\e[00m%}'

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

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=25000
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

# Temporary custom aliases
alias 'ps=ps -dcl L'
alias 'vnc=ssh -f -L 9999:localhost:5901 ada2358@pacman.ccs.neu.edu \ vncviewer -encodings tight localhost::9999 -passwd ~/.vnc/passwd'
alias 'vncs=vncserver -nolisten tcp -localhost -nevershared -geometry 1278x945'

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
alias 'dis=~/bin/distribute.sh'
alias 'tot=~/bin/total_summary'
alias 'lm=linuxmachines'
alias 'tu=top -u'
alias 'ta=top -u ada2358'
alias 'chweb=chmod -R 755 ~/.www'
alias 'chcourse=chmod -R 755 ~/classes/*/*'

# Shortcuts
alias 'tmp=cd /var/tmp/adam'
alias 'hm=cd ~'
alias 'web=cd ~/.www'
alias 'cw=cd ~/Adam\ Blackwell/Course\ Work'
alias '1=cd ~/classes/cs2600'
alias '2=cd ~/classes/cs3500'
alias '3=cd ~/classes/cs3600'
alias '4=cd ~/classes/cs4700'

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

# SSH aliases
alias 'sshp=ssh -X ada2358@zerowing.ccs.neu.edu'
alias 'sshg=ssh -X ada2358@galaga.ccs.neu.edu'
alias 'sshl=ssh -X ada2358@login-linux.ccs.neu.edu'
alias 'ssha=ssh -X ada2358@pacman.ccs.neu.edu'
alias 'sshs=ssh -X ada2358@seawolf.ccs.neu.edu'
alias 'sshb=ssh -X ada2358@blueprint.ccs.neu.edu'
alias 'ssho=ssh -X ada2358@octui.com'
alias 'sshy=ssh -X ada2358@gyruss.ccs.neu.edu'
alias 'ssht=ssh -X ada2358@timepilot.ccs.neu.edu'

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
    if [[ -z ${~PWD:#${HOME}/documents*} ||
	        -z ${~PWD:#${HOME}/imperial*}  ||
	        -z ${~PWD:#${HOME}}            ||
	        -z ${~PWD:#$/tmp/Adam/*}       ]] then
        if [[ $(umask) -ne 077 ]] then
            umask 0077
            echo -e "\033[01;32mUmask: private \033[m"
	      fi
    fi
    # Group executable
  #  if [[ -z ${~PWD:#${HOME}/.irssi*} ||
  #        -z ${~PWD:#${HOME}/.irssi/*}]] then
  #      if [[ $(umask) -ne 067 ]] then
  #          umask 0067
  #          echo -e "\033[01;32mUmask: group exacutable \033[m"
  #      fi
  #  fi 
    # Web permissions
    if [[ -z ${~PWD:#/.www*}       ||
        # -z ${~PWD:#/matt/web*}   ||
          -z ${~PWD:#${HOME}/www*} ]] then
        if [[ $(umask) -ne 072 ]] then
            umask 0072
            echo -e "\033[01;33mUmask: other readable \033[m"
        fi
    fi
    # Group writable permissions
    if [[ -z ${~PWD:#/vol/linux*}      ||
      	  -z ${~PWD:#${HOME}/Public/*}       ||
		      -z ${~PWD:#${HOME}/Adam\ Blackwell/Data/*}    ||
		      -z ${~PWD:#${HOME}/Adam\ Blackwell/Public/*}  ]] then
        if [[ $(umask) -ne 002 ]] then
		        umask 0002
		        echo -e "\033[01;35mUmask: group writable \033[m"
        fi
    fi
    # World readable
    if [[ -z ${~PWD:#${HOME}/.irssi/scripts}   ||
          -z ${~PWD:#${HOME}/.irssi/scripts/*} ]] then 
        if [[ $(umask) -ne 022 ]] then
		        umask 0022
		        echo -e "\033[01;31mUmask: world readable \033[m"
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

# CD into random directory in PWD
cdrand () {
	all=( *(/) )
	rand=$(( 1 + $RANDOM % $#all ))
	cd $all[$rand]
}

# Print some stuff
if [[ -x `which date` ]]; then
    date
    echo
fi
if [[ -x `which fortune` ]]; then
    fortune -a 2> /dev/null
fi

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

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
