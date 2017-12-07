#! /usr/bin/env zsh

# A simple script for setting up OSX dev environment.
dotfile_dir="$HOME/dotfiles"

# Ask for sudo permission at start
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Try to encapsulate the installation into methods
print_message() {
    local message=$1
    echo .
    echo .
    echo $message
    echo .
    echo .
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
    local pathname=$1 
    local destination=$2 
    local permission=${3:-644}

    echo "File ~/.$(basename $pathname) doesn't exists. Creating it in $destination..."
    touch "$destination"
    chmod "$permission" "$destination"

    print_message "Linking $destination to $pathname"
    ln -sf "$pathname" "$destination"
}

download_dotfile_directory() {
    # initially git will not be available
    print_message "Downloading dotfiles repo...."
    curl -sSLOk https://github.com/rahulrrixe/dotfiles/archive/master.zip && \ 
                                unzip master.zip -d $HOME && \ 
                                rm -rf master.zip && mv $HOME/dotfiles-master $dotfile_dir
    cd $dotfile_dir
}

clone_dotfile_git_repo() {
    create_dir $HOME/Code
    git clone https://github.com/rahulrrixe/dotfiles.git $HOME/Code
}

change_shell() {
    print_message "Changing shell to ZSH..."
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
}

install_prezto() {
    print_message "Installing prezto..."
    
    if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi

    setopt EXTENDED_GLOB
    for rcfile in ${ZDOTDIR:-$HOME}/.zprezto/runcoms/^README.md\(.N\); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
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
    create_file_and_symlink "$dotfile_dir/karabiner" "$HOME/.config"
}

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then

    ##############################################
    # Start the install process.                 #
    ##############################################
    download_dotfile_directory

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
    # Xcode Command Line                         #
    ##############################################
    print_message "Setting up commad line tools..."

    sh $dotfile_dir/osx/xcode_setup.sh


    ##############################################
    # dotfiles                                   #
    ##############################################
    if [ ! -d $Home/Code/dotfiles ]; then
        clone_dotfile_git_repo
    fi

    ##############################################
    # ZSH                                        #
    ##############################################
    print_message "Installing ZSH..."

    if ! type "zsh" > /dev/null; then
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
    # zshrc                                      #
    ##############################################
    install_prezto

    ##############################################
    # Pygments & Pip                             #
    ##############################################
    print_message "Installing Python pip...."
    sudo easy_install Pygments
    sudo easy_install pip

    ##############################################
    # Symlinks                                  #
    ##############################################
    symlink_dotfiles

    ##############################################
    # OSX                                        #
    ##############################################
    echo 'Do you want to reconfigure system setting?'
    echo 'n / y'
    read give_links
        [[ "$give_links" == 'y' ]] && sh $dotfile_dir/osx/sensible_defaults.sh 

    ###############################################
    # SSH
    ###############################################
    print_message 'Checking for SSH key, generating one if it does not exist...'

    if [ ! -f '$HOME/.ssh/id_rsa.pub' ]; then 
        ssh-keygen -t rsa

        echo 'Copying public key to clipboard. Paste it into your Github account...'
        [[ -f '$HOME/.ssh/id_rsa.pub' ]] && cat '$HOME/.ssh/id_rsa.pub' | pbcopy
        open 'https://github.com/account/ssh'
    fi

    ##############################################
    # Apps                                       #
    ##############################################
    echo 'Do you want to install app from brew bundle?'
    echo 'n / y'
    read give_links
        [[ "$give_links" == 'y' ]] && brew bundle --file="$dotfile_dir/Brewfile" 

    ############################################
    # Vim 
    ############################################
    print_message "installing VIM vundle package manager..."
    if [ ! -d "$HOME/.vim/bundle" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    
    create_dir "$HOME/.vim/tmp"
    create_dir "$HOME/.vim/backup"    
    sh vim +PluginInstall
    #############################################
    # XVim
    ############################################

    print_message "Done :)"
fi

# If on Linux, install zsh
if [[ `uname` != 'Darwin' ]]; then
  which -s zsh
  if [[ $? != 0 ]]; then
    echo 'Installing zsh and prezto...'
    sudo apt-get install zsh curl
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  fi
fi
