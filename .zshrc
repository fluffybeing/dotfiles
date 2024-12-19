ENABLE_CORRECTION="false"

# Sets the window title nicely no matter where you are
DISABLE_AUTO_TITLE="true"
_set_terminal_title() {
  local title="$(basename "$PWD")"
  if [[ -n $SSH_CONNECTION ]]; then
    title="$title \xE2\x80\x94 $HOSTNAME"
  fi
  print -Pn "\e]2;$title\a"
}
# Call the function before displaying the prompt
precmd_functions+=(_set_terminal_title)

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Activate Fish-like autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#homebrew
[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable Fish-like syntax highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/binutils/lib"
export CPPFLAGS="-I/opt/homebrew/opt/binutils/include"
export SDKROOT="`xcrun --show-sdk-path`"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export EDITOR="nvim"
# Go
export PATH="$PATH:$(go env GOPATH)/bin"
export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_FALLBACK_LIBRARY_PATH

# Flutter
export PATH="$PATH:/usr/local/opt/flutter/bin"
export PATH="$PATH:/usr/local/opt/flutter/bin/cache/dart-sdk/bin"

# Android
export ANDROID_HOME="/Users/rranjan/Library/Android/sdk"

# JAVA
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH=$JAVA_HOME/bin:$PATH
export PATH="/opt/homebrew/opt/gradle@7/bin:$PATH"

# Flags for C++
export ITERM_24BIT=1

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Ruby
eval "$(rbenv init -)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "/Users/rranjan/.bun/_bun" ] && source "/Users/rranjan/.bun/_bun"


# Python
alias python="/opt/homebrew/bin/python3"
alias pip="/opt/homebrew/bin/pip3"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"

# OpenSSL
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"


###################
# Library path
####################
export PATH="/Library/Developer/CommandLineTools/usr/bin:$PATH"

################################
# Alias
# ##############################
# ##############################
alias untar='tar -zxvf' # Unpack .tar file
alias hs='history | grep'
alias wget='wget -c' # Download and resume
alias getpass='openssl rand -base64 20' # Generate password
alias sha='shasum -a 256' # Check shasum
alias ping='ping -c 5' # Limit ping to 5'
alias www='python -m http.server' # Run local web server

###################
#iOS  Workflow
####################
alias cs="xcrun simctl erase all"
alias sgp="swift package generate-xcodeproj"
alias ddd="rm -rf ~/Library/Developer/Xcode/DerivedData"

################
# Work Related
################
xbuild() {
  XCODE_SCHEME="FLIR One Preview"
  XCODE_WORKSPACE="FLIR One.xcworkspace"
  /opt/homebrew/bin/pod install
  xcrun xcodebuild \
  -scheme $XCODE_SCHEME \
  -workspace $XCODE_WORKSPACE \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build
}

###################
# Git
###################
alias gpr='git pull origin development --rebase'
alias gpp='"$(gpr)" && git push origin "$(git-branch-current 2> /dev/null)"'


################
# Neovim
################
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"

# Limit CPU usage of a process
limitCPU() {
  cpulimit -l 20 -p $(pgrep -f $1)
}

# Make a new directory and cd into it
take() {
  \mkdir -p "$1" && cd "$1"
}

# Emacs
alias org="emacs $HOME/Dropbox/org/"

# Enable aliases to be sudo’ed
alias sudo="sudo "

# Easier navigation
alias .='pwd'
alias ..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias cd..='cd ..'
alias -- -="cd -" # previous working directory

# Hot-access directories
alias library="cd $HOME/Library"
alias projects="cd $HOME/Code"

# zshrc config
alias zshrc="$EDITOR ~/.zshrc"
alias reload="source ~/.zshrc && echo 'Shell config reloaded from ~/.zshrc'"
alias s="reload"

# Sane defaults for built-ins (verbose and interactive)
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep="grep -i --color=auto"
alias mkdir="mkdir -p"

# Typos
alias sl="ls"
alias gut="git"
alias gti="git"
alias mdkir="mkdir"
alias brwe="brew"

# Shortcuts
alias ls="ls --color"
alias l="ls -l"
alias -- +x="chmod +x"
alias o="open"
alias oo="open ."
alias g="git"
alias d="docker"
alias dc="docker compose"
alias e="$EDITOR"
alias c="code ."
alias cc="code ."
alias where="which"
alias pn="pnpm"
alias nvm="fnm"

# Apps

# Git client
alias t="github ."

# Lazydocker
alias ld="lazydocker"

# File Manager
alias ff="open -a 'Marta' ."

#
# Built-ins upgrades
#

command_exists() {
  command -v "$@" &> /dev/null
}

# Bat: https://github.com/sharkdp/bat
command_exists bat && alias cat="bat --style=plain"

# Fd: https://github.com/sharkdp/fd
command_exists fd && alias find="fd"

# Eza: https://eza.rocks/
# ---------------------
# eza universal Dracula
# ---------------------
export EZA_COLORS="\
uu=36:\
uR=31:\
un=35:\
gu=37:\
da=2;34:\
ur=34:\
uw=95:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:\
xx=95:"
# Display all clickable entries (incl. hidden files) as a grid with icons
command_exists eza && alias ls="eza -a --icons=auto --color=always --group-directories-first"
# Display a detailed list of clickable entries (incl. hidden files) with a Git status
command_exists eza && alias ll="ls --long --no-user --header -g --git"
# Display clickable directory tree
command_exists eza && alias llt="ls --tree --git-ignore"

# Safer reversible file removal: https://github.com/sindresorhus/trash-cli
command_exists trash && alias rm="trash"

# Htop: https://htop.dev/
command_exists htop && alias top="htop"

# Tlrc: https://github.com/tldr-pages/tlrc
command_exists tldr && alias man="tldr --config ~/.tlrc.toml"

# Prettyping: https://denilson.sa.nom.br/prettyping/
command_exists prettyping && alias ping="prettyping --nolegend"

# Download file and save it with the name of the remote file in the current working directory
# Usage: get <URL>
alias get="curl -O -L"

#
# macOS
#

# System
alias shut="sudo shutdown -h now"
alias restart="sudo shutdown -r now"

# Show/hide all desktop icons (useful when presenting)
alias showdesk="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedesk="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"


# Starship powerline
eval "$(starship init zsh)"

# Mise
eval "$(mise activate zsh)"

# Convert cd to cd >> ls
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ ls }

####
[ -f ~/.ai ] && source ~/.ai

