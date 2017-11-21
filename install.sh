#! /usr/bin/env zsh

# A simple script for setting up OSX dev environment.
dev="$HOME/Code/dotfiles"

# Ask for sudo permission at start
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

create_dir() {
    local dirname=$1

    if [[ ! -d $dirname ]]; then 
        echo "--> $dirname"
        mkdir -p $dirname 2>/dev/null
        echo ""
    fi
}

create_file_and_symlink() {
    local pathname=$1 destination=$2 permission=${3:-644}

    echo "--> $pathname"
    if [ -L $destination ] && [ -e $destination ]; then
        echo "$destination is already a symbolic link to $pathname"
        return
    else
        echo "File ~/.$(basename $pathname) doesn't exists. Creating it in $destination..."
        touch "$destination"
        chmod "$permission" "$destination"
    
        echo "Linking $destination to $pathname"
        ln -sf "$pathname" "$destination"
        echo ""
    fi
}

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then

    ##############################################
    # Xcode Command Line                         #
    ##############################################
    echo "Setting up commad line tools \n"
    sh $dev/osx/xcode_setup.sh

    #############################################
    # Homebrew                                  #
    #############################################
    which -s brew
    if [[ $? != 0 ]]; then
      echo 'Installing Homebrew...'
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew update
        brew tap Homebrew/bundle
        brew install git
    fi

    ##############################################
    # dotfiles                                   #
    ##############################################
    dir="$HOME/Code"
    create_dir $dir
    cd $dir
    
    if [ ! -d "dotfiles" ]; then
        echo "Downloading dotfiles repo \n"
        git clone https://github.com/rahulrrixe/dotfiles.git
        cd dotfiles
    fi

    ##############################################
    # ZSH                                        #
    ##############################################
    echo "Installing ZSH"
    if ! type "zsh" > /dev/null; then
      brew install zsh 
      brew install zsh-completions
    fi

    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi

    brew_zsh_path="/usr/local/bin/zsh"
    if [[ $(which zsh) == $brew_zsh_path ]]; then
        # For mac user we need to change the shell for user
        dscl . -create /Users/$USER UserShell $brew_zsh_path
    fi
    ##############################################
    # zshrc                                      #
    ##############################################
    echo "Installing prezto \n"
    
    if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi

    setopt EXTENDED_GLOB
    for rcfile in ${ZDOTDIR:-$HOME}/.zprezto/runcoms/^README.md\(.N\); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done

    ##############################################
    # Pygments & Pip                             #
    ##############################################
    echo "Installing Python pip \n"
    sudo easy_install Pygments
    sudo easy_install pip

    ##############################################
    # Symlinks                                  #
    ##############################################
    echo "Symlinks config files \n"
    declare -a files=("zsh/zshrc" "zsh/zshenv" "vim/vimrc" "xvim/xvimrc"
                      "tmux/tmux" "tmux/tmux.conf")

    for file in "${files[@]}"; do
        f=${file}
        f=${f##*/}
        create_file_and_symlink $dev/$file ~/.$f
    done
    ##############################################
    # OSX                                        #
    ##############################################
    echo 'Do you want to reconfigure system setting?'
    echo 'n / y'
    read give_links
        [[ "$give_links" == 'y' ]] && sh $dev/osx/sensible_defaults.sh 

    ###############################################
    # SSH
    ###############################################
    echo 'Checking for SSH key, generating one if it does not exist...'
    if [ ! -e '$HOME/.ssh/id_rsa.pub' ]; then 
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
        [[ "$give_links" == 'y' ]] && brew bundle --file="$dev/Brewfile" 

    ############################################
    # Vim 
    ############################################
    if [ ! -d "$HOME/.vim/bundle" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    
    create_dir "~/.vim/tmp"
    create_dir "~/.vim/backup"    
    #############################################
    # XVim
    ############################################

    echo "Done :)"
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
