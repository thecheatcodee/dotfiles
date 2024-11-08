# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# ZSH_THEME="frontcube" # use starship instead

# Set list of themes to pick from when loading at random
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
# plugins+=(zsh-vi-mode)


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

OS_TYPE=$(uname)
if [[ $OS_TYPE == "Darwin" ]]; then
  # do something for macos
elif [[ $OS_TYPE == "Linux" ]]; then
  # do something for linux
fi

# PATH stuff
export GOPATH=$HOME/Documents/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/X11/bin:$PATH"
export PATH="/Applications/Alacritty.app/Contents/MacOS/:$PATH"


# source "$HOME/.rye/env"
. "$HOME/.cargo/env"

export EDITOR=nvim 

# Alias
alias man='tldr'
alias vim='nvim '
alias ls='eza --color=always --git --icons=always --no-user'
alias cat='bat '
alias y='yazi '
alias py='python '
alias nvd='neovide --frame buttonless --title-hidden'
alias e='$EDITOR'
alias sudo='sudo -E '
alias ze='zellij attach'
alias neofetch='fastfetch'
alias grep='rg'
alias find='fd'
# alias ls='eza --color=always --long --git --icons=always --no-user'
# alias cd='z '


export LANG=en_US.UTF-8

# ============================ FZF ===================================
# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git  . $HOME' 
# export FZF_CTRL_R_COMMAND=""
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # CTRL-T to fuzzily search for a file or directory in your home directory then insert its path at the cursor 
export FZF_CTRL_T_OPTS='--walker-skip .git,node_modules,target,Library,Applications,Music'
#   --preview 'bat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_COMMAND='fd -t d --hidden --exclude .git . $HOME' # ALT-C to fuzzily search for a directory in your home directory then cd into it
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"


# ================== SOME CUSTOM COMMANDS =============================

# Blog
export MYBLOG_DIR="$HOME/Documents/myblog/"
alias blog="cd $MYBLOG_DIR"
alias blog_publish="cd $MYBLOG_DIR && hugo && rsync -vau -e 'ssh -p 22000' --delete ~/Documents/myblog/public/ zach@ssh.thecheatcode.site:~/Services/nginx/nginx/html/myblog "
alias bp='blog_publish'


# Proxy
function proxy_on() {
    export http_proxy=http://127.0.0.1:7897
    export https_proxy=$http_proxy
    echo -e "终端代理已开启。"
}

function proxy_off(){
    unset http_proxy https_proxy
    echo -e "终端代理已关闭。"
}

# Alacritty theme switcher
alias themes="ls ~/.config/alacritty/themes/themes | fzf | xargs -I {} ln -sf ~/.config/alacritty/themes/themes/{} ~/.config/alacritty/current_theme.toml && echo "@@@" >> ~/.config/alacritty/alacritty.yml && sed -i '/@@@/d' ~/.config/alacritty/alacritty.yml"

# ========================= VI MODE =================================

bindkey -v
# Remove mode switching delay.
KEYTIMEOUT=5

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]]  ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]]     ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor for each new prompt.
_fix_cursor() { echo -ne '\e[5 q' }
precmd_functions+=(_fix_cursor)

# ========================= Init =================================
eval "$(fzf --zsh)"
eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
