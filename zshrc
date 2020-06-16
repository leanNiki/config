# zsh Config

# load env variables
[ -f "$HOME/.config/env" ] && source "$HOME/.config/env"

# zsh Options
## History
HISTFILE=~/.config/zsh/history
HISTSIZE=10000
SAVEHIST=10000
bindkey '^R' history-incremental-search-backward

setopt alwaystoend
setopt autocd
setopt autolist
setopt automenu
setopt extendedglob
setopt histignorealldups
setopt incappendhistory
setopt nobeep
setopt nocaseglob
setopt nomenucomplete
setopt numericglobsort
setopt pathdirs



# urxvt line-wrap fix
for (( i=1; i<=$LINES; i++ )); do echo; done; clear

# Autojump
source /etc/profile.d/autojump.sh

## Aliases
alias bm='bashmount'
alias cputemp='sensors'
alias g='git'
alias l='ls --color'
alias ls='ls --color'
alias la='ls -al --color'
alias ll='ls -l --color'
alias s='shutdown'
alias wm='sudo wifi-menu'
alias we='~/bin/getweather.sh'
alias xo='xdg-open'
alias youtube-dl-mp3='youtube-dl --extract-audio --audio-format mp3 --prefer-ffmpeg'


# docker apps

# az update: uncomment below alias, download kubectl, docker commit <container-id> az
alias az='docker run -it --rm \
	-v ~/.azure:/root/.azure \
	-v ~/.ssh:/root/.ssh \
	--net host \
	az'

#alias az-d='docker run -it --rm \
#	-v ~/.azure:/root/.azure \
#	-v ~/.ssh:/root/.ssh \
#	--net host \
#	microsoft/azure-cli'

alias freecad='docker run -it --rm \
	-e DISPLAY=unix$DISPLAY \
	-v /tmp/.X11-unix \
	-v $HOME/.Xauthority:/root/.Xauthority \
	-v $HOME/doc:/root/documents \
	--net=host \
	izone/freecad freecad-git'

# Prompt
## Enable prompt themes
autoload -Uz promptinit
promptinit

## enable git display
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr "+"
zstyle ':vcs_info:git*' formats " %b %u%c "
precmd() {
	vcs_info
}

setopt PROMPT_SUBST
bg1=blue
fg1=black
bg2=red
fg2=black

#uncomment for powerline, need to have patched fonts installed
#export PS1='%K{$bg1}%F{$fg1} $(fish-dir) %K{$bg2}%F{$bg1}%F{$fg2}${vcs_info_msg_0_}%k%F{$bg2}%f'
export PS1='%K{$bg1}%F{$fg1} %~ %K{$bg2}%F{$fg2} ${vcs_info_msg_0_}%k%f'

# Completion System (mostly copied from eriner/zim)
# Enable autocomplete
autoload -Uz compinit
compinit

# completion module options
# group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion 
# directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
zstyle ':completion:*' squeeze-slashes true
# enable caching
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-${HOME}}/.zcompcache"
# ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'
# completion sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
# ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
# smart editor completion
zstyle ':completion:*:(nano|vim|nvim|vi|emacs|e):*' ignored-patterns '*.(wav|mp3|flac|ogg|mp4|avi|mkv|webm|iso|dmg|so|o|a|bin|exe|dll|pcap|7z|zip|tar|gz|bz2|rar|deb|pkg|gzip|pdf|mobi|epub|png|jpeg|jpg|gif)'

# move around completionmenu with vi bindings
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
