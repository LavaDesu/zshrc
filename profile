autoload -U colors && colors
echo "${bold_color}${fg[magenta]}Heowo!"
echo "Current time: $(date "+%A, %d %B %Y %T")${reset_color}"

# Autostart X
#if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#	echo "Starting X"
#	exec startx
#fi

# History
HISTFILE=~/.local/share/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
setopt inc_append_history
setopt share_history

# Prompt
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
#PS1="%B%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$reset_color%}"$'\n'"$%b "

# Auto/tabcomplete
autoload -U compinit
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' '+l:|=* r:|=*'
zstyle ':completion:*' menu select
_comp_options+=(globdots)
zmodload zsh/complist
compinit

# vi mode
bindkey -v
export KEYTIMEOUT=5
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# other stuff
bindkey -v '^?' backward-delete-char
bindkey -v '^R' history-incremental-pattern-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Start plugins
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/exports"
source "$ZDOTDIR/plugins/loader"
