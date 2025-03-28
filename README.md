# dotfiles

This is my personal dotfile setup.

Below command will start the setup process

```bash
bash -c "$(curl -sL https://raw.githubusercontent.com/rakontuh/dotfiles/master/install.sh)"
```

### Extra Setup

1. Enable Firewall under `System Settings → Network`

2. Point the DNS Servers to Cloudflare DNS
   - 1.1.1.1
   - 1.0.0.1
   - 2606:4700:4700::1111
   - 2606:4700:4700::1001


### Cursor vim key repeat
If the key repeat is not working run this following command.

```
defaults write "$(osascript -e 'id of app "Cursor"')" ApplePressAndHoldEnabled -bool false
or 
defaults write -app Cursor ApplePressAndHoldEnabled -bool false
defaults delete -g ApplePressAndHoldEnabled
```

### Conda showing env info twice
Conda shows the activated env twice, to avoid that run the following command

```
conda config --set changeps1 False
```
