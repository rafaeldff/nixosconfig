#!  /usr/bin/env bash
cd $HOME

[[ ! -e ./homedir ]] && git clone Dropbox/homedir homedir

[[ ! -e ./.xmonad ]] &&  mkdir ~/.xmonad

[[ ! -e ./.xmonad/xmonad.hs  ]] && ln -s ~/homedir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs

[[ ! -e ./.local/share/fonts  ]] && ln -s ~/homedir/.fonts ~/.local/share/fonts

[[ ! -e ./.xmonad ]] &&  mkdir ~/temp

[[ ! -e ./bin ]] &&  ln -s ~/homedir/bin ~/bin

git config --global user.email rafael@rafaelferreira.net
git config --global user.name "Rafael de F. Ferreira"

