#! /usr/bin/env zsh

# A simple script for setting up OSX dev environment.
dev="$HOME/Code/dotfiles"

# Ask for sudo permission at start
sudo -v

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
    if [ ! -d "${dir}" ]; then
        mkdir -p $dir
    fi

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
    if [ -f /bin/zsh -o -f /usr/bin/zsh -o -f /usr/local/bin/zsh ]; then
      brew install zsh 
      brew install zsh-completions
    fi

    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
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
    declare -a files=("zsh/zshrc" "zsh/zshenv" "vim/vimrc"
                      "git/gitconfig")

    for file in "${files[@]}"; do
        f=${file}
        f=${f##*/}
        echo "Creating symlink to $file in home directory."
        ln -s $dev/$file ~/.$f
    done
    ##############################################
    # OSX                                        #
    ##############################################
    echo 'Do you want to reconfigure system setting?'
    echo 'n / y'
    read give_links
        [[ "$give_links" == 'y' ]] && sh $dev/osx/sensible_defaults.sh 
    popd

    ###############################################
    # SSH
    ###############################################
    echo 'Checking for SSH key, generating one if it does not exist...'
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
        [[ "$give_links" == 'y' ]] && brew bundle
    popd
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
