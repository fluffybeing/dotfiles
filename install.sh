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
# Utils
######################################################
print_message() {
    local message=$1
    echo "$message....."
}

create_dir() {
    local dirname=$1

    if [[ ! -d $dirname ]]; then
        echo "--> $dirname"
        mkdir -p $dirname 2>/dev/null
        echo ""
    fi
}

clone_dotfile_git_repo() {
    git clone https://github.com/fluffybeing/dotfiles.git $dotfile_dir
}

############
# Use Zsh
###############
change_shell() {
    print_message "Changing shell to ZSH..."
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
}

install_prezto() {
    print_message "Installing prezto"

    if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi

    setopt EXTENDED_GLOB
    for rcfile in "'${ZDOTDIR:-$HOME}'/.zprezto/runcoms/^README.md\(.N\)"; do
        ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
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
    if ! xcode-select --print-path &>/dev/null; then
        print_message "[info] command line tools setup"
        xcode-select --install &>/dev/null

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &>/dev/null; do
            sleep 5
        done
    fi

    #############################################
    # Homebrew                                  #
    #############################################
    which -s brew
    if [[ $? != 0 ]]; then
        print_message '[info] Installing Homebrew...'
        
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        brew update
        brew tap Homebrew/bundle
        brew install git
        brew tap homebrew/cask-fonts
        brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
    fi

    ##############################################
    # dotfiles                                   #
    ##############################################
    if [ ! -d $dotfile_dir ]; then
        print_message "[info] Cloning the dotfiles in $dotfile_dir"
        clone_dotfile_git_repo

        if [ ! -d $dotfile_dir ]; then 
            print_message "[error] Dotfile directory is not available"
            exit
        fi
    fi

    ##############################################
    # Xcode Command Line                         #
    ##############################################
    print_message "[info] Setting up commad line tools..."
    sh $dotfile_dir/osx/xcode_setup.sh

    ##############################################
    # ZSH                                        #
    ##############################################
    print_message "Installing ZSH..."

    if ! type "zsh" >/dev/null; then
        brew install zsh
        brew install zsh-completions
    fi

    change_shell

    brew_zsh_path="/usr/local/bin/zsh"
    if [[ $(which zsh) == $brew_zsh_path ]]; then
        # For mac user we need to change the shell for user
        dscl . -create /Users/$USER UserShell $brew_zsh_path
    fi

    ##############################################
    # OSX                                        #
    ##############################################
    echo 'Do you want to reconfigure system setting? This will change your computer name and other system default settings'
    echo 'n / y'
    read give_links
    if [[ "$give_links" == 'y' ]]; then
        sh $dotfile_dir/osx/sensible_defaults.sh
    fi

    ###############################################
    # SSH
    ###############################################
    print_message 'Checking for SSH key, generating one if it does not exist...'
    if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
        ssh-keygen -t rsa

        echo 'Copying public key to clipboard. Paste it into your Github account...'
        [[ -f '$HOME/.ssh/id_rsa.pub' ]] && cat '$HOME/.ssh/id_rsa.pub' | pbcopy
        open 'https://github.com/account/ssh'
    fi
    print_message "The keys exists"

    ##############################################
    # Apps                                       #
    ##############################################
    echo 'Do you want to install app from brew bundle?'
    echo 'n / y'
    read give_links
    if [[ "$give_links" == 'y' ]]; then
        brew bundle --file="$dotfile_dir/Brewfile"
    fi

    ##############################################
    # zshrc                                      #
    ##############################################
    install_prezto

    ##############################################
    # Symlinks                                  #
    ##############################################
    sh cd $dotfile_dir
    sh stow .
    
    print_message "Done :) :) :)"
fi