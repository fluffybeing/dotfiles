#!/bin/sh

# Ask for admin password upfront
sudo -v

echo 'You might need to change your default shell to zsh: `chsh -s /bin/zsh` (or `sudo vim /etc/passwd`)'

# Install ZSH
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Change the shell
chsh -s $(which zsh)

# Directory where all the dotfile will get downloaded
dir="$HOME/Code"
mkdir -p $dir
cd $dir

# Clone the repo from github a
git clone https://github.com/rahulrrixe/dotfiles.git
cd dotfiles
sudo bash bootstrap_new_system.sh
