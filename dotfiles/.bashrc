#!/bin/bash

# Default .bashrc
# Original Author: Samuel Roeca
#
# Use this file to:
#   Import .profile and ~/.bash/sensitive (using the provided "include")
#   Execute some "basic" commands
#   Define bash aliases and functions
#   Note: do NOT place sensitive information (like passwords) in this file
# if using vim:
#   za: toggle one fold
#   zi: toggle all folds

#######################################################################
# Set up environment and PATH
#######################################################################

# Functions --- {{{

today(){
  echo This is a `date +"%A %d in %B of %Y (%r)"` return
}

export R_EXTRA_CONFIGURE_OPTIONS='--enable-R-shlib --with-cairo'

export PYTHON_CONFIGURE_OPTS='--enable-shared'

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

path_ladd() {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

path_radd() {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# Log into Redshift integration general by vault cli
kipint_amer() {
  vauth
  echo '---'
  local host="rs-analytics-integration.keplergrp.com"
  local kipint_pw=$(vault read -field=redshift_creds -format=json secret/integration/kip-s3-to-redshift-ingestion/amer/secure | jq '.general["password"]')
  local ipaddr=$(dns_lookup $host)
  PGPASSWORD=$kipint_pw FRIENDLY_HOSTNAME="integration-amer" psql -h $host -U kepleradmin -p 5439 -d general
}

# Get the nth row from a given file on s3
nth_row() {
  # 1st arg: s3 path
  # 2nd arg: row # that triggered the stl load error
  # example: nth_row s3://testingcopy/zliu/test.csv 32
  # to extract and display the 32nd row of this file
  local filename=$(basename -- "$1")
  local extension="${filename##*.}"
  # fiq: file in question
  local local_filename="fiq.${filename}"

  # copy the s3 file to local box
  aws s3 cp $1 $local_filename

  # deal with compressed file
  local proceed=true
  local comp_type=$(file $local_filename)
  if [[ "$comp_type" == *"bzip2"* ]]; then
    bzip2 -d $local_filename
    # trim the extension because it's decompressed
    local local_filename=${local_filename%.*}
  elif [[ "$comp_type" == *"bz2"* ]]; then
    bzip2 -d $local_filename
    # trim the extension because it's decompressed
    local local_filename=${local_filename%.*}
  elif [[ "$comp_type" == *"gzip"* ]]; then
    gunzip $local_filename
    # trim the extension because it's decompressed
    local local_filename=${local_filename%.*}
  else
    if [[ $extension != "csv" && $extension != "tsv" && $extension != "json" ]]; then
      tput setaf 1;
      echo -e "Attention: this file is of $extension extension!"
      echo -e "Can't deal with '$comp_type' this type of file yet!"
      proceed=false
    fi
  fi

  if [[ $proceed = "true" ]]; then
    # extract the row that caused the issue
    local txt_type=$(file $local_filename)
    local total_lines=$(wc -l < $local_filename)
    if (( $2 > $total_lines )); then
      tput setaf 1;
      echo -e "The line you want to see exceed total lines $total_lines"
      proceed=false
    else
      echo "========== See data below =========="
      if [[ "$txt_type" == *"JSON"* ]]; then
        sed "${2}q;d" $local_filename | jq
      else
        sed "${2}q;d" $local_filename
      fi
    fi
  fi

  # clean-up: remove the downloaded files immediately in case it has PII info
  if [ -f $local_filename ]; then
    rm $local_filename
  fi
  if [[ $proceed = "false" ]]; then
    false
  fi
}
# }}}
# Exported variable: LS_COLORS --- {{{
# Colors when using the LS command
# NOTE:
# Color codes:
#   0   Default Colour
#   1   Bold
#   4   Underlined
#   5   Flashing Text
#   7   Reverse Field
#   31  Red
#   32  Green
#   33  Orange
#   34  Blue
#   35  Purple
#   36  Cyan
#   37  Grey
#   40  Black Background
#   41  Red Background
#   42  Green Background
#   43  Orange Background
#   44  Blue Background
#   45  Purple Background
#   46  Cyan Background
#   47  Grey Background
#   90  Dark Grey
#   91  Light Red
#   92  Light Green
#   93  Yellow
#   94  Light Blue
#   95  Light Purple
#   96  Turquoise
#   100 Dark Grey Background
#   101 Light Red Background
#   102 Light Green Background
#   103 Yellow Background
#   104 Light Blue Background
#   105 Light Purple Background
#   106 Turquoise Background
# Parameters
#   di 	Directory
LS_COLORS="di=1;34:"
#   fi 	File
LS_COLORS+="fi=0:"
#   ln 	Symbolic Link
LS_COLORS+="ln=1;36:"
#   pi 	Fifo file
LS_COLORS+="pi=5:"
#   so 	Socket file
LS_COLORS+="so=5:"
#   bd 	Block (buffered) special file
LS_COLORS+="bd=5:"
#   cd 	Character (unbuffered) special file
LS_COLORS+="cd=5:"
#   or 	Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="or=31:"
#   mi 	Non-existent file pointed to by a symbolic link (visible with ls -l)
LS_COLORS+="mi=0:"
#   ex 	File which is executable (ie. has 'x' set in permissions).
LS_COLORS+="ex=1;92:"
# additional file types as-defined by their extension
LS_COLORS+="*.rpm=90"

# Finally, export LS_COLORS
export LS_COLORS

# }}}
# Exported variables: General --- {{{

# React
export REACT_EDITOR='less'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Configure less (de-initialization clears the screen)
# Gives nicely-colored man pages
export PAGER=less
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --clear-screen'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# tmuxinator
export EDITOR=vim
export SHELL=bash

# environment variable controlling difference between HI-DPI / Non HI_DPI
# turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: ignore leading space commands, keep lines in memory
export HISTCONTROL=ignorespace
export HISTSIZE=5000

# }}}
# Path appends + Misc env setup --- {{{

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}

#######################################################################
# Interactive Bash session settings
#######################################################################

# Import from other Bash Files --- {{{

include () {
  [[ -f "$1" ]] && source "$1"
}

include ~/.bash/sensitive

# }}}
# Executed Commands --- {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
stty -ixon

# }}}
# Aliases --- {{{

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Neovim
# Make "vim" direct to nvim
alias vim=nvim
alias f='nvim'
alias ovc='nvim ~/.dotfiles/dotfiles/.config/nvim/init.vim'
alias obc='nvim ~/.dotfiles/dotfiles/.bashrc'

# Log in AWS console with specified aws region (add emea or amer after aws-console)
alias aws-console='bash ~/src/joan/shell_scripts/login_aws_profiles.sh'

# ls aliases
alias ll='ls -alF'
alias l='ls -CF'

# Set copy/paste helper functions
# the perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"

# Git
alias g="git status"
alias ga="git add ."
alias gm="git commit"
alias gb="git branch"
alias gcm="git checkout master"
alias gp="git pull"
alias staging="gh pr comment -b staging"

# Frequent repos, cd the repo and activate the Python virtual environment
alias cd-airflow="cd KIP-Airflow-DAGs; source venv/bin/activate"
alias cd-athena="cd KIP-Athena-Ingestion; source venv/bin/activate"
alias cd-s3="cd KIP-S3-To-S3-Transfer; source venv/bin/activate"
alias cd-spark="cd KIP-Spark-Transformation; source venv/bin/activate"
alias cd-sftp="cd KIP-SFTP-To-S3-Transfer; source venv/bin/activate"
alias cd-gsheet="cd KIP-Googlesheet-Ingestion; source venv/bin/activate"
alias cd-redash="cd KIP-Redash-To-Platform-Transfer; source venv/bin/activate"
alias cd-datorama="cd KIP-S3-To-Datorama-Transfer; source venv/bin/activate"
alias cd-create="cd KIP-Create-To-S3-Transfer; source venv/bin/activate"

# Make build and tests
alias mbt="make build-test"
alias run-gha="ENV=integration make run-gha-test"

# reload bashrc
alias rbc="source ~/.bashrc; echo 'Reloaded ~/.bashrc'"

# activate/deactivate python virtual environment
alias apv="source venv/bin/activate"
alias de="deactivate"

# tmux
alias tkw="tmux kill-window"

# turn on wifi
alias wifi-on="nmcli radio wifi on"
# cd to the folders above
# alias .='cd ..'
# alias ..='cd ../..'
# alias ...='cd ../../..'
# alias ....='cd ../../../..'
# alias .....='cd ../../../../..'

# }}}
# Functions --- {{{

# Example functions...

# Clubhouse story template
clubhouse() {
  echo -e "## Objective\n## Value\n## Acceptance Criteria" | pbcopy
}

# Reload bashrc
so() {
  source ~/.bashrc
}

# }}}
# Command line prompt (PS1) --- {{{

COLOR_BRIGHT_GREEN="\033[38;5;10m"
COLOR_BRIGHT_BLUE="\033[38;5;115m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_PURPLE="\033[1;35m"
COLOR_ORANGE="\033[38;5;202m"
COLOR_BLUE="\033[34;5;115m"
COLOR_WHITE="\033[0;37m"
COLOR_GOLD="\033[38;5;142m"
COLOR_SILVER="\033[38;5;248m"
COLOR_LIGHT_RED="\033[1;31m"
COLOR_RESET="\033[0m"
BOLD="$(tput bold)"

# Set Bash PS1
PS1_DIR="\[$BOLD\]\[$COLOR_LIGHT_RED\]\w"
PS1_USR="\[$BOLD\]\[$COLOR_GOLD\]\u@\h"
PS1_END="\[$BOLD\]\[$COLOR_SILVER\]$ \[$COLOR_RESET\]"

PS1="${PS1_DIR}\
${PS1_USR} ${PS1_END}"

# }}}
# ASDF: environment manager setup {{{

source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

# }}}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${COLOR_GOLD}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $ "

# Colors definition
BLUE='\e[1;94m'
L_BLUE='\e[96m'
YELLOW='\e[93m'
DARK_BLUE='\e[34m'
L_GREEN='\e[92m'
RED='\e[31m'
L_RED='\e[91m'
NC='\e[0m'

export GIT_PS1_SHOWDIRTYSTATE=true        # show * for changes
export GIT_PS1_SHOWUNTRACKEDFILES=true    # show % for new files
export PS1="$DARK_BLUE\u$YELLOW@$L_GREEN\h$YELLOW: $BLUE\W $L_RED\ $ "
export PS1="\$(set_virtualenv) \[\e[0;34m\]\h\[\e[0;32m\]@$BLUE\W \[\e[0;37m\]\@ $L_RED\$(__git_ps1)$NC \[\e[0;35m\]$\[\e[0m\] "
# Set the full bash prompt.
function set_bash_prompt () {

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}\[\e[0;34m\]\h\[\e[0;32m\]@$BLUE\W \[\e[0;37m\]\@ $L_RED \[\e[0;35m\]$\[\e[0m\] "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
