#!/bin/sh

echo 'You might need to change your default shell to zsh: `chsh -s /bin/zsh` (or `sudo vim /etc/passwd`)'

# Install ZSH
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

dir="$HOME/code/personal"
mkdir -p $dir
cd $dir

# Clone the repo from github a
git clone https://github.com/rahulrrixe/dotfiles.git
cd dotfiles
sudo bash bin/symlink-dotfiles.sh