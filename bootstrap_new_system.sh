#!/usr/bin/env zsh


# Taken from https://github.com/paulmillr/dotfiles

# A simple script for setting up OSX dev environment.
dev="$HOME/Code"
pushd .
mkdir -p $dev
cd $dev

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      ruby -e "$(/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install)"
      brew update
      brew tap Homebrew/bundle
      brew bundle
  fi
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


# For MacOS
if [[ `uname` == 'Darwin' ]]; then
  echo 'Enter new hostname of the machine (e.g. macbook-rahul)'
    read hostname
    echo "Setting new hostname to $hostname..."
    scutil --set HostName "$hostname"
    compname=$(sudo scutil --get HostName | tr '-' '.')
    echo "Setting computer name to $compname"
    scutil --set ComputerName "$compname"

  echo 'Checking for SSH key, generating one if it does not exist...'
    [[ -f '~/.ssh/id_rsa.pub' ]] || ssh-keygen -t rsa

  echo 'Copying public key to clipboard. Paste it into your Github account...'
    [[ -f '~/.ssh/id_rsa.pub' ]] && cat '~/.ssh/id_rsa.pub' | pbcopy
    open 'https://github.com/account/ssh'

  open_apps() {
    echo 'Install apps:'
    echo 'Dropbox:'
    open https://www.dropbox.com
    echo 'Chrome:'
    open https://www.google.com/intl/en/chrome/browser/
    echo 'VLC:'
    open http://www.videolan.org/vlc/index.html
  }

  echo 'Should I give you links for system applications (e.g. Skype, Tower, VLC)?'
  echo 'n / y'
  read give_links
  [[ "$give_links" == 'y' ]] && open_apps
  popd
fi

