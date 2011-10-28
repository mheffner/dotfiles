# /etc/skel/.bashrc:

# This file is sourced by all *interactive* bash shells on startup.  This
# file *should generate no output* or it will break the scp and rcp commands.

if [ -e /etc/bashrc ]; then
	. /etc/bashrc
fi

# Bail fast!
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


#
# Aliases
#
eval `dircolors -b /etc/DIR_COLORS`
alias ls="ls"
alias ll="ls -al"
alias ll="ls -al"
alias ls-al="ls -al"
alias sl="ls"
alias lcvs="cvs -d spock@hedwig:/cvs"
alias fbsdscvs="cvs -d mikeh@ncvs.freebsd.org:/home/ncvs"
alias fbsdpcvs="cvs -d mikeh@pcvs.freebsd.org:/home/pcvs"
alias ffile="find . -name"
alias emnw="emacs -nw"
alias ackpg="ack --pager='less -R'"
alias pjson="python -mjson.tool"
alias be="bundle exec"
alias bi="bundle install --path .bundle/gems"

# This will get me all the time
alias ci=vi

alias rpmqvendor='rpm -qa --queryformat "%{NAME}-%{VENDOR}\n"'
alias run-enscript='enscript --media=Letter -GEc -fCourier7 -r -j -2 -v -C --lines-per-page=120'

alias makeit='make -s clean && make -s all && make -s install'

alias unrarit='unrar x -y'

#
# Convenience functions (ie., aliases with parameter support)
#
function gr() { grep -Irn "$@" .; }
function svndiffls() { svn diff $@ | grep ^Index | cut -d " " -f 2; }
function gitdiffc() { git diff --no-prefix $1^!; }
function cdls() { cd $1 && ls; }

# use correct remote?...defaults to origin
function grb() {
    if [ $# -eq 1 ]; then
        git rebase $1
        return $?
    fi

    # Else, rebase to origin/<current branch>
    BR=$(git branch | egrep '^\*' | cut -d ' ' -f 2)
    if [ -z "$BR" ]; then
        echo "Can't determine branch"
        return 1
    fi

    git rebase origin/$BR
}

# Switch AWS environment. Assumes each environ file
# is an '$HOME/.ec2/$1/env'
function aws()
{
	source $HOME/.ec2/$1/env
}

# Generate the Cassandra node's token value given its INDEX and the
# TOTAL number of nodes
function tokidx()
{

	if [ $# -ne 2 ]; then
		echo "Usage: tokidx INDEX TOTAL"
		return 1
	fi

	ruby -e 'puts ARGV[0].to_i * (2 ** 127 - 1) / ARGV[1].to_i' $1 $2
}

#
# Environment
#
export PATH=$HOME/bin:$PATH
export SVNROOT=svn+ssh://svn.santaclara.librato.com/opt/svn/cdc
export NSVNROOT=svn+ssh://nagini.fesnel.com/var/svn/mikeh

export FLEX3_HOME=$HOME/tmp/flexsdk
export FLEX4_HOME=$HOME/tmp/flexsdk4

export FLEX_HOME=${FLEX4_HOME}

export FZLIB_HOME=$HOME/tmp/fzlib/FZlib

export MOZ_PLUGIN_PATH=$HOME/.firefox/plugins

#export LANG=C

#
# Editor
#
which emacs &> /dev/null
if [ $? -eq 0 ]; then
	export EDITOR=emacs
else
	which vim &> /dev/null
	if [ $? -eq 0 ]; then
	   export EDITOR=vim
	else
	   export EDITOR=vi
	fi
fi

export SVN_EDITOR=$HOME/bin/svncitemp.sh
export SVN_REAL_EDITOR=$EDITOR


# Key bindings
export INPUTRC=$HOME/.inputrc

# History
export HISTSIZE=1024
HISTIGNORE='&'

# Coresize
ulimit -c 10240000

# Prompt
export PROMPT_DIRTRIM=3

function getwintitle()
{

    case $TERM in
	xterm*|rxvt|Eterm|eterm)
	    # Set icon title
	    printf "\[\e]1;\h:\`basename '\w'\`\007\]"
	    # Set window title
	    printf "\[\e]2;\h:\w\007\]"
	    ;;
	screen)
	    printf "\[\e_\h:\w\e\\"
	    ;;
	*)
	    ;;
    esac
}

# Emulate %c from tcsh
# Stolen from: http://bsdjlh.blogspot.com/2009/02/bash-prompt-trick-cheap-emulation-of.html
# (with minor mods)
function traildir()
{
    local n=$1 dir=$2
    local sl tildedir homelen shifted  traildir
    local oldifs=$IFS

    tildedir=${dir#$HOME}
    if ! [[ "$tildedir" == "$dir" ]]; then
            # Special break out case
            [[ -z "$tildedir" ]] && { echo "~"; return 0; }

            sl="~/"
    else
            sl="/"
    fi

    set -- ${HOME//\// }
    homelen=$#

    shifted=0
    IFS="/"
    set -- ${tildedir/\//}
    if [[ $# -gt $n ]]; then
            shifted=$(($# - $n))
            shift $shifted
            traildir="$sl<$shifted>/$*"
    else
            traildir="$sl$*"
    fi

    IFS=$oldifs
    echo $traildir
}

#
# Manage Heroku credentials based on name
#
function hunset() {
  rm -f $HOME/.heroku/credentials
}

function hset() {
  hunset
  ln -sf $HOME/.heroku/credentials_$1 $HOME/.heroku/credentials
}

function hsave() {
  mv $HOME/.heroku/credentials $HOME/.heroku/credentials_$1
}

# List credentials with a * in front of active one
function hlist() {
  ls $HOME/.heroku/credentials_* |  \
	awk -v n=`readlink $HOME/.heroku/credentials` \
	'/.*credentials_(.*)$/{if ($1 == n) printf "*"; gsub(/^.*credentials_/, ""); print $0}'
}

#
# Startup s3sh with correct variables
#
function mys3sh() {
    AMAZON_ACCESS_KEY_ID="$S3_KEY" AMAZON_SECRET_ACCESS_KEY="$S3_SECRET" s3sh
}


##uncomment the following to activate bash-completion:
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#
# Command completion
#
. $HOME/.bash_completion_git.sh
complete -C $HOME/.bash_completion_rake.rb -o default rake


# Show dirty state
export GIT_PS1_SHOWDIRTYSTATE=1

TRAILPWD=3
export PS1="\h\\[\e[1;31m\]\$(__git_ps1 \"(%s)\")\[\e[m\]:\[\`tput bold\`\]\$(traildir \$TRAILPWD \"\$PWD\")\[\`tput sgr0\`\]$ `getwintitle`"

# Display exit status of previous command on failure
#
function printexitvalue()
{
	local SAVE_EXIT=$?

	if [ $SAVE_EXIT -ne 0 ]; then
	   echo "Exit $SAVE_EXIT";
	fi

	return $SAVE_EXIT
}
export PROMPT_COMMAND=printexitvalue

#
# bash does not play well with rxvt
# XXX: no idea if this is generally a good fix???
#
if [ "$TERM" = "rxvt" ]; then
    export TERM=xterm
fi

#
# Source devel bash file if it exists
#
if [ -e $HOME/.bash.dev ]; then
   . $HOME/.bash.dev
fi

#
# Source private bash file if it exists
#
if [ -e $HOME/.bash.priv ]; then
   . $HOME/.bash.priv
fi

# --Xemacs--
#
# -*- Local Variables:
# -*- mode:shell-script
# -*- End:
