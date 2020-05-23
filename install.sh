#! /usr/bin/env zsh

# A simple script for setting up OSX dev environment.
dotfile_dir="$HOME/Dropbox/Code/dotfiles"

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

create_file_and_symlink() {
    local realfile=$1
    local virtualfile=$2
    local permission=${3:-644}

    touch "$virtualfile"
    chmod "$permission" "$virtualfile"

    print_message "Linking $virtualfile to $realfile"
    ln -sf "$realfile" "$virtualfile"
}

clone_dotfile_git_repo() {
    create_dir "$HOME/Dropbox/Code"
    git clone https://github.com/coyo8/dotfiles.git $dotfile_dir
}

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
    for rcfile in "${ZDOTDIR:-$HOME}/.zprezto/runcoms/^README.md\(.N\)"; do
        ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
}

symlink_dotfiles() {
    print_message "Symlinking files..."
    declare -a files=("zsh/zshrc" "zsh/zshenv" "zsh/zpreztorc" "vim/vimrc" "xvim/xvimrc"
        "tmux/tmux" "tmux/tmux.conf" "git/gitignore" "git/gitconfig")

    for file in "${files[@]}"; do
        f=${file}
        f=${f##*/}
        create_file_and_symlink $dotfile_dir/$file ~/.$f
    done
    # some symlinks are not so straight forward
    create_file_and_symlink "$dotfile_dir/karabiner/karabiner.json" "$HOME/.config/karabiner.json"
    # create_file_and_symlink "$dotfile_dir/emacs/init.el" "$HOME/.emacs.d/init.el"
}

#############################
# Start                     #
#############################
# If we on OS X, install homebrew and tweak system a bit.
if [[ $(uname) == 'Darwin' ]]; then

    ##############################################
    # Xcode utils                                #
    ##############################################
    if ! xcode-select --print-path &>/dev/null; then
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
        print_message 'Installing Homebrew...'
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew update
        brew tap Homebrew/bundle
        brew install git
    fi

    ##############################################
    # dotfiles                                   #
    ##############################################
    if [ ! -d $dotfile_dir ]; then
        clone_dotfile_git_repo
    fi

    ##############################################
    # Xcode Command Line                         #
    ##############################################
    print_message "Setting up commad line tools..."

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

    #############################################
    # Powerline Fonts
    ############################################
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    sh ./install.sh
    cd ..
    rm -rf fonts

    ##############################################
    # Symlinks                                  #
    ##############################################
    chown -R `whoami` ~/.config   
    symlink_dotfiles

    # symlink for special emacs
    ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    sh $HOME/.emacs.d/bin/doom install

    ##############################################
    # zshrc                                      #
    ##############################################
    install_prezto

    print_message "Done :)"
fi

##############################################
# TODO: Add setups for apps
##############################################

# If on Linux, install zsh
if [[ $(uname) != 'Darwin' ]]; then
    which -s zsh
    if [[ $? != 0 ]]; then
        echo 'Installing zsh and prezto...'
        sudo apt-get install zsh curl
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi
fi
