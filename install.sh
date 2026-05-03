#! /usr/bin/zsh

# A simple script for setting up OSX dev environment.
dotfile_dir="$HOME/dotfiles"

# Ask for sudo permission at start
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

######################################################
# Logging
######################################################
RED=$'\033[0;31m'
YELLOW=$'\033[0;33m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

log_step()    { printf "\n${BOLD}==> %s${RESET}\n" "$1"; }
log_info()    { printf "${BLUE}[info]${RESET}  %s\n" "$1"; }
log_warn()    { printf "${YELLOW}[warn]${RESET}  %s\n" "$1"; }
log_error()   { printf "${RED}[error]${RESET} %s\n" "$1" >&2; }
log_success() { printf "${GREEN}[done]${RESET}  %s\n" "$1"; }

######################################################
# Utils
######################################################
create_dir() {
  local dirname=$1

  if [[ ! -d $dirname ]]; then
      log_info "Creating directory: $dirname"
      mkdir -p $dirname 2>/dev/null
  fi
}

clone_dotfile_git_repo() {
    git clone https://github.com/fluffybeing/dotfiles.git $dotfile_dir
}

############
# Use Zsh
###############
change_shell() {
    local zsh_path="/bin/zsh"

    if [[ "$SHELL" == "$zsh_path" ]]; then
        log_info "Shell is already set to $zsh_path"
        return
    fi

    log_info "Setting default shell to $zsh_path"
    sudo dscl . -create "/Users/$USER" UserShell "$zsh_path"
    log_success "Default shell set to $zsh_path"
}

install_prezto() {
    log_info "Installing Prezto"

    if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        log_success "Prezto cloned"
    else
        log_info "Prezto already installed"
    fi
    # RC file symlinks are managed by stow — do not create them here
}

##########################################################################
##########################################################################
# Start                                                                  #
##########################################################################
# If we on OS X, install homebrew and tweak system a bit.
if [[ $(uname) == 'Darwin' ]]; then

    ##############################################
    # Xcode utils                                #
    ##############################################
    log_step "Xcode Command Line Tools"
    if ! xcode-select --print-path &>/dev/null; then
        log_info "Installing Xcode Command Line Tools"
        xcode-select --install &>/dev/null

        log_info "Waiting for Xcode Command Line Tools to finish installing..."
        until xcode-select --print-path &>/dev/null; do
            sleep 5
        done
        log_success "Xcode Command Line Tools installed"
    else
        log_info "Xcode Command Line Tools already installed"
    fi

    #############################################
    # Homebrew                                  #
    #############################################
    log_step "Homebrew"
    which -s brew
    if [[ $? != 0 ]]; then
        log_info "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew update
        brew tap Homebrew/bundle
        brew install git
        brew tap homebrew/cask-fonts
        brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
        log_success "Homebrew installed"
    else
        log_info "Homebrew already installed"
    fi

    ##############################################
    # dotfiles                                   #
    ##############################################
    log_step "Dotfiles"
    if [ ! -d $dotfile_dir ]; then
        log_info "Cloning dotfiles to $dotfile_dir"
        clone_dotfile_git_repo

        if [ ! -d $dotfile_dir ]; then
            log_error "Dotfile directory unavailable after clone — aborting"
            exit 1
        fi
        log_success "Dotfiles cloned"
    else
        log_info "Dotfiles already present at $dotfile_dir"
    fi

    ##############################################
    # Xcode Command Line                         #
    ##############################################
    log_step "Xcode setup"
    log_info "Running Xcode setup script"
    sh $dotfile_dir/osx/xcode_setup.sh

    ##############################################
    # ZSH                                        #
    ##############################################
    log_step "ZSH"
    if ! type "zsh" >/dev/null; then
        log_info "Installing ZSH"
        brew install zsh
        brew install zsh-completions
    else
        log_info "ZSH already installed"
    fi

    change_shell

    ##############################################
    # OSX                                        #
    ##############################################
    log_step "macOS system settings"
    printf "Reconfigure system settings (computer name, defaults, etc.)? [y/n]: "
    read give_links
    if [[ "$give_links" == 'y' ]]; then
        log_info "Applying macOS sensible defaults"
        sh $dotfile_dir/osx/sensible_defaults.sh
        log_success "macOS settings applied"
    fi

    ###############################################
    # SSH
    ###############################################
    log_step "SSH key"
    if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
        log_info "No SSH key found — generating one"
        ssh-keygen -t rsa
        log_info "Copying public key to clipboard — paste it into your GitHub account"
        cat "$HOME/.ssh/id_rsa.pub" | pbcopy
        open 'https://github.com/account/ssh'
    else
        log_info "SSH key already exists"
    fi

    ##############################################
    # Apps                                       #
    ##############################################
    log_step "Homebrew bundle"
    printf "Install all apps from Brewfile? [y/n]: "
    read give_links
    if [[ "$give_links" == 'y' ]]; then
        log_info "Installing apps from Brewfile"
        brew bundle --file="$dotfile_dir/Brewfile"
        log_success "Brewfile apps installed"
    fi

    ##############################################
    # zshrc                                      #
    ##############################################
    log_step "Prezto"
    install_prezto

    ##############################################
    # Symlinks                                   #
    ##############################################
    log_step "Symlinks"
    log_info "Stowing dotfiles"
    # .stow-local-ignore controls what gets excluded (e.g. .git, Brewfile, install.sh)
    (cd "$dotfile_dir" && stow --simulate . 2>&1 \
        | awk '/existing target is not owned by stow:/ {print $NF}' \
        | while IFS= read -r target; do
            log_warn "Removing conflicting target: $target"
            rm -f "$HOME/$target"
        done)
    (cd "$dotfile_dir" && stow .)

    ##############################################
    # Agentic Development                        #
    ##############################################
    log_step "Agentic development tools"
    printf "Set up agentic development tools (Copilot CLI plugin + agent skills)? [y/n]: "
    read setup_agentic
    if [[ "$setup_agentic" == 'y' ]]; then

        # Install GitHub Copilot CLI plugin for agentic workflow
        if command -v gh &>/dev/null; then
            log_info "Installing Copilot agentic workflow plugin"
            gh copilot plugin install rug-agentic-workflow@awesome-copilot
            log_success "Copilot plugin installed"
        else
            log_warn "GitHub CLI (gh) not found — skipping Copilot plugin install"
            log_warn "Install manually: gh copilot plugin install rug-agentic-workflow@awesome-copilot"
        fi

        # Install Apple platform agent skills
        # Each command is interactive: choose target agents and global/project scope
        log_info "Installing SwiftUI Pro agent skill (interactive)"
        npx skills add https://github.com/twostraws/swiftui-agent-skill --skill swiftui-pro

        log_info "Installing SwiftData Pro agent skill (interactive)"
        npx skills add https://github.com/twostraws/swiftdata-agent-skill --skill swiftdata-pro

        log_info "Installing Swift Testing Pro agent skill (interactive)"
        npx skills add https://github.com/twostraws/swift-testing-agent-skill --skill swift-testing-pro

        log_success "Agentic development tools installed"
    fi

    log_success "Setup complete!"
fi
