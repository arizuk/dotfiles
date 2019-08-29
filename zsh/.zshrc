# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="candy"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"
if [[ -d "$HOME/.zsh-completions/src" ]]; then
	fpath=($fpath ~/.zsh-completions/src)
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)
if [ `uname` = 'Darwin' ]; then
	plugins=($plugins brew)
fi
source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#- theme
function git_branch_info() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%I:%M:%S]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_branch_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#-- alias
alias ls='ls -G'
alias ll='ls -l'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias tmux="tmux -2 -u"
alias h="history"

alias -g L="|less"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

source ~/.zshrc.local;
export _Z_DATA=~/.z.data/z;
source ~/.z.sh/z.sh;

function chpwd() {
    ls;
}

setopt extended_glob

# カッコの対応などを自動的に補完
setopt auto_param_keys

# スペルチェック
setopt correct

# zmv
autoload -Uz zmv
alias zmv='noglob zmv'
alias groot='cd $(git rev-parse --show-toplevel)'

# When a file path given, goes to the directory.
function cdd()
{
  if [ -d "$1" ]; then
    local dir=$1
  else
    local dir=$(dirname $1)
  fi
  cd $dir
}

#-- widget
function _git_status()
{
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo git status
        git status
    fi
    zle reset-prompt
}
zle -N git_status _git_status
bindkey '^G^S' git_status

setopt hist_ignore_all_dups

function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
# bindkey '^z' peco-z-search

function peco-git-diff-files()
{
    file=$(cat <(git diff --name-only) <(git diff --cached --name-only)|sort|uniq|peco --prompt "[select file]")
    BUFFER="${BUFFER}${file}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-git-diff-files
# bindkey '^g' peco-git-diff-files


function peco-find-file()
{
    if git rev-parse 2> /dev/null; then
        source_files=$(git ls-files)
    else
        source_files=$(find . -type f)
    fi
    selected_files=$(echo $source_files | peco --prompt "[find file]")

    result=''
    for file in $selected_files; do
        result="${result}$(echo $file | tr '\n' ' ')"
    done

    BUFFER="${BUFFER}${result}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-find-file
# bindkey '^q' peco-find-file

function percol_select_history()
{
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER             # move cursor
    zle -R -c                   # refresh
}
zle -N percol_select_history
# bindkey '^R' percol_select_history

## utilities powered by sk
function sk-select-history()
{
    BUFFER=$(fc -l -n 1 | sk --tac --query "$LBUFFER")
    CURSOR=$#BUFFER             # move cursor
    zle -R -c                   # refresh
}
zle -N sk-select-history

function sk-z-move()
{
  local res=$(z | sort -rn | cut -c 12- | sk)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N sk-z-move

# Git related commands
function sk-git-select-modified-files()
{
    file=$(cat <(git diff --name-only) <(git diff --cached --name-only)|sort|uniq|sk -m --prompt "[select file]"|tr '\n' ' ')
    BUFFER="${BUFFER}${file}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N sk-git-select-modified-files

function sk-git-select-files()
{
    files=$(git ls-files $(git rev-parse --show-toplevel)|sk -m --prompt "[find file]" --preview "preview.sh {}"|tr '\n' ' ')
    BUFFER="${BUFFER}${files}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N sk-git-select-files

function sk-select-files()
{
    files=$(sk -m --ansi -i -c 'ag -g "{}"' --preview "preview.sh {}" |cut -d: -f1,2|tr '\n', ' ')
    BUFFER="${BUFFER}${files}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N sk-select-files

function sk-open-files()
{
    files=$(sk -m --ansi -i -c 'ag --color "{}"' --preview "preview.sh {}" |cut -d: -f1,2|tr '\n', ' ')
    if [ ! -z "${files}" ]; then
      BUFFER+="code -g ${files}"
      zle accept-line
    fi
    return 1
}
zle -N sk-open-files

function sk-git-cd()
{
    dir=$(git ls-files $(git rev-parse --show-toplevel)| sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g' | sort | uniq|sk)
    if [ ! -z "${dir}" ]; then
      BUFFER+="cd ${dir}"
      zle accept-line
    fi
    return 1
}
zle -N sk-git-cd

which sk > /dev/null
if [ $? -eq 0 ]; then
  bindkey '^R' sk-select-history
  bindkey '^z' sk-z-move
  bindkey '^g^f' sk-git-select-files
  bindkey '^g^m' sk-git-select-modified-files
  bindkey '^g^r' sk-select-files
  bindkey '^g^o' sk-open-files
  bindkey '^g^a' sk-git-cd
fi
