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
# Put Xcode path first
export PATH="/Library/Developer/CommandLineTools/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export PATH="/opt/homebrew/opt/gradle@7/bin:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"

# Compiler and Tools
export CC="/opt/homebrew/opt/llvm/bin/clang"
export CXX="/opt/homebrew/opt/llvm/bin/clang++"
export LDFLAGS="-L/opt/homebrew/opt/binutils/lib"
export CPPFLAGS="-I/opt/homebrew/opt/binutils/include"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Java
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# Android
export ANDROID_HOME="/Users/rranjan/Library/Android/sdk"

# Ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# Editor
export EDITOR="nvim"
export ITERM_24BIT=1

# Dynamic Library Path
export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_FALLBACK_LIBRARY_PATH

# SDK
export SDKROOT="`xcrun --show-sdk-path`"

# NVM
export NVM_DIR="$HOME/.nvm"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# bun completions
[ -s "/Users/rranjan/.bun/_bun" ] && source "/Users/rranjan/.bun/_bun"
# NVM
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"

################################
# Alias
################################

# General Aliases
alias ..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias .='pwd'
alias cd..='cd ..'
alias -- -="cd -" # previous working directory
alias ls="ls --color"
alias l="ls -l"
alias -- +x="chmod +x"
alias o="open"
alias oo="open ."
alias e="$EDITOR"
alias c="code ."
alias cc="code ."
alias where="which"
alias python="python3"
alias pip="pip3"

# iOS Workflow
alias cs="xcrun simctl erase all"
alias spmg="swift package generate-xcodeproj"
alias ddd="rm -rf ~/Library/Developer/Xcode/DerivedData"

# Work Related
alias projects="cd $HOME/Code"
alias library="cd $HOME/Library"

# Neovim
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"

# Emacs
alias org="emacs $HOME/Dropbox/org/"

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
alias magit="gitu"

# Shortcuts
alias g="git"
alias d="docker"
alias dc="docker compose"
alias pn="pnpm"
alias nvm="fnm"

# Apps
alias t="github ."
alias ld="lazydocker"
alias ff="open -a 'Marta' ."

# Built-ins upgrades
command_exists() {
  command -v "$@" &> /dev/null
}
# Bat: https://github.com/sharkdp/bat
command_exists bat && alias cat="bat --style=plain"
# Fd: https://github.com/sharkdp/fd
command_exists fd && alias find="fd"
# Eza: https://eza.rocks/
command_exists eza && alias ls="eza -a --icons=auto --color=always --group-directories-first"
command_exists eza && alias ll="ls --long --no-user --header -g --git"
command_exists eza && alias llt="ls --tree --git-ignore"
# Safer reversible file removal: https://github.com/sindresorhus/trash-cli
command_exists trash && alias dd="trash"
# Htop: https://htop.dev/
command_exists htop && alias top="htop"
# Tlrc: https://github.com/tldr-pages/tlrc
command_exists tldr && alias man="tldr --config ~/.tlrc.toml"
# Prettyping: https://denilson.sa.nom.br/prettyping/
command_exists prettyping && alias ping="prettyping --nolegend"

# System
alias shut="sudo shutdown -h now"
alias restart="sudo shutdown -r now"

# Show/hide all desktop icons (useful when presenting)
alias showdesk="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedesk="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# zshrc config
alias zshrc="$EDITOR ~/.zshrc"
alias reload="source ~/.zshrc && echo 'Shell config reloaded from ~/.zshrc'"
alias s="reload"

# Starship powerline
eval "$(starship init zsh)"
# Mise
# eval "$(mise activate zsh)"
# Convert cd to cd >> ls
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ ls }

# AI chat key
[ -f ~/.ai ] && source ~/.ai

# Tuist
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

# Set pip to use the user site-packages directory by default
export PIP_USER=true

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

