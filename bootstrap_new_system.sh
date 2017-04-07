#!/usr/bin/env zsh


# Taken from https://github.com/paulmillr/dotfiles

# A simple script for setting up OSX dev environment.
dev="$HOME/Code/dotfiles"
pushd .
mkdir -p $dev
cd $dev

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
      brew update
      brew install htop hub
      brew install zsh
      brew install coreutils
      git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
      git clone https://github.com/zsh-users/antigen.git "$HOME/.antigen"

      # Install xcode command line
      if ! xcode-select --print-path &> /dev/null; then

        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &> /dev/null; do
          sleep 5
        done

        print_result $? 'Install XCode Command Line Tools'

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13
        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        print_result $? 'Make "xcode-select" developer directory point to Xcode'

        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10
        sudo xcodebuild -license
        print_result $? 'Agree with the XCode Command Line Tools licence'

      fi

  fi

  echo 'Tweaking OS X...'
    source 'etc/osx.sh'
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

echo 'Symlinking config files...'
  source 'bin/symlink-dotfiles.sh'

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
