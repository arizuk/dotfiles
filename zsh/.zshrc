# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

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
alias sk="sk --layout=reverse --ansi"
alias skp='sk --layout=reverse --ansi --preview="preview.sh {}"'
alias g='cd $(ghq root)/$(ghq list|sk)'
alias groot='cd $(git rev-parse --show-toplevel)'
alias -g X="|xargs -o"
alias -g "$"="|xargs -o"
alias -g L="|less"

# z
export _Z_DATA=~/.z.data/z;
source ~/.z.sh/z.sh;

setopt extended_glob
setopt auto_param_keys # カッコの対応などを自動的に補完
setopt correct # スペルチェック
setopt hist_ignore_all_dups

# zmv
autoload -Uz zmv
alias zmv='noglob zmv'

function chpwd() {
    ls;
}

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

##-- utilities powered by sk
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
    files=$(ag -g ".*"|sk -m --preview "preview.sh {}")
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
    dir=$(git ls-files $(git rev-parse --show-toplevel)|sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g'|sort|uniq|sk)
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

source ~/.zshrc.local;
