#!/usr/bin/env zsh


# Taken from https://github.com/paulmillr/dotfiles

# A simple script for setting up OSX dev environment.
dev="$HOME/Code/dotfiles"


# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then

    ##############################################
    # Xcode Command Line                         #
    ##############################################
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
    mkdir -p $dir
    cd $dir

    # Clone the repo from github a
    git clone https://github.com/rahulrrixe/dotfiles.git
    cd dotfiles
    sudo bash bootstrap_new_system.sh

    ##############################################
    # zshrc                                      #
    ##############################################
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    source ~/.zshrc

    ##############################################
    # Pygments & Pip                             #
    ##############################################
    sudo easy_install Pygments
    sudo easy_install pip

    ##############################################
    # Symlinks                                  #
    ##############################################
    declare -a files=("zsh/oh-my-zsh" "zsh/zshrc" "zsh/zshenv" "vim/vimrc"
                      "git/gitconfig")

    for file in "${files[@]}"; do
        f=${file}
        f=${f##*/}
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv ~/.$f ~/dotfiles_old/
        echo "Creating symlink to $file in home directory."
        ln -s $dev/$file ~/.$f
    done
    ##############################################
    # OSX                                        #
    ##############################################
    sh $dev/osx/sensible_defaults.sh


    ##############################################
    # Oh My ZSH                                  #
    ##############################################
    if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
      if [[ ! -d $dir/oh-my-zsh/ ]]; then
        sh -c "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh"
      fi
    fi

    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi

    # setting
    ln -s $dev/zsh/rahul.zsh-theme $HOME/.oh-my-zsh/themes

    ##############################################
    # Iterm                                      #
    ##############################################
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    
    ##############################################
    # Apps                                       #
    ##############################################
    brew bundle
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
