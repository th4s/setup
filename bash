# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set DIRTY flag to true to enable dirty-marked commands
DIRTY=true

# Set PATH
PATH="$PATH:$HOME/.local/bin"

# Always cd into folders in home folder, no matter where we are
CDPATH=.:~

# Set nvim as our editor
if [[ -f "/usr/bin/nvim" ]]; then
    export EDITOR=/usr/bin/nvim
elif [[ -f "/usr/bin/vim" ]]; then
    export EDITOR=/usr/bin/vim
fi

# Clear terminal history
alias delhistory='cat /dev/null > ~/.bash_history && history -c'

# Update rust
if [[ -d "$HOME/.cargo" ]]; then
    alias rsup='rustup update && cargo install-update --all'
fi

# DIRTY: Set up internet when connected to dock
if [[ "$DIRTY" = true ]]; then
    alias netup='sudo ip link set enp6s0f3u1u1 up && sudo systemctl restart dhcpcd'
fi

# Some frequent shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


if [[ -f "/usr/bin/xdg-open" ]]; then
    alias open='xdg-open'
fi

if [[ -f "/usr/bin/exa" ]]; then
    alias ls='exa'
    alias ll='exa -alF'
    alias tree='exa -lF --tree --git-ignore'
fi

if [[ -f "/usr/bin/git" ]]; then
    alias gs='git status -sb'
    alias ga='git add -A'
    alias gd='git diff HEAD'
    alias gl='git log'
fi

# Simple variant of locate
# shows path of a file 
function where() {
    find . -iname "*$1*"
}

# We can query the internet for awesome terminal command help
function cheat() {
    curl cht.sh/$1
}

# Lookup weather in city ...
function weather() {
    curl wttr.in/$1
}

if [[ "$DIRTY" = true ]]; then
    function switch_net() {
        wpa_cli list_networks
        read -n 1 -p "Please select a network: " NETWORK
        wpa_cli select_network $NETWORK
    } 
fi

# Replace capslock with additional CTRL
setxkbmap -option caps:ctrl_modifier

# Some hotkeys for tmux
if [[ -f "/usr/bin/tmux" ]]; then
    alias t="tmux"
    alias ta="t a -t"
    alias tls="t ls"
    alias tn="t new -t"
fi

# Search through history with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# A simple calculator in terminal
calc() {
    echo "scale=3;$@" | bc -l
}

# Configure xclip
if [[ -f "/usr/bin/xclip" ]]; then
    # copy to clipboard
    alias xc="xclip -se c"
    # copy to pirmary buffer
    alias xb="xclip"
fi

# Source rust stuff
if [[ -d "$HOME/.cargo" ]]; then
    . "$HOME/.cargo/env"
fi

# Source node-version manager
if [[ -d "/usr/share/nvm" ]]; then
    . "/usr/share/nvm/init-nvm.sh"
fi

# Source git-prompt and set PS1
if [[ -f "~/.git-prompt.sh" ]]; then
    . "$HOME/.git-prompt.sh"
    
    # Set prompt_command to display git informationSource
    PROMPT_COMMAND='__git_ps1 "\[\033[38;5;33m\]\u@\h\[\033[0m\]|\w" "\\\$ "'
    
    #Some git prompt modification
    GIT_PS1_SHOWCOLORHINTS=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
else
    PS1='\[\033[38;5;33m\]\u@\h\[\033[0m\]|\w$ '
fi
