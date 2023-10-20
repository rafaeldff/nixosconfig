#!  /usr/bin/env bash
set -x
shopt -s nullglob

if grep -Eqi 'Name="?Ubuntu"?' /etc/os-release; then
  echo Loading ubuntu settings;
  ./ubuntu/install.sh
fi

cd $HOME
echo Setting up Home

[[ ! -e ./homedir ]] && git clone git@github.com:rafaeldff/homedir homedir

[[ ! -e ./.bashrc ]] && ln -s ~/homedir/.bashrc ~/.bashrc

[[ ! -e ./.xmonad ]] &&  mkdir ~/.xmonad

[[ ! -e ./.xmonad/xmonad.hs  ]] && ln -s ~/homedir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs

[[ ! -e ~/.config/xmobar/xmobarrc  ]] && {
  mkdir -p ~/.config/xmobar 
  ln -s ~/homedir/xmobarrc ~/.config/xmobar/xmobarrc
} 

[[ ! -e ./.local/share/fonts  ]] && ln -s ~/homedir/.fonts ~/.local/share/fonts

[[ ! -e ./temp ]] &&  mkdir ~/temp

[[ ! -e ./bin ]] &&  ln -s ~/homedir/bin ~/bin

[[ ! -e ./.dircolors ]] &&  ln -s ~/homedir/misc/ls-colors-solarized/dircolors ~/.dircolors

if [[ ! -e ./.vim ]] ; then
  echo Setting up vim
  pushd homedir
  git submodule update --init --recursive
  popd
  pwd
  
  [[ ! -e ./.vim ]] &&  ln -s ~/homedir/.vim ~/.vim
  [[ ! -e ./.vimrc ]] &&  ln -s ~/homedir/.vim/vimrc ~/.vimrc
  [[ ! -e ./.gvimrc ]] &&  ln -s ~/homedir/.vim/gvimrc ~/.gvimrc
  [[ ! -e ./.vim/backup ]] &&  mkdir ./.vim/backup
  [[ ! -e ./.vim/swp ]] &&  mkdir ./.vim/swp
fi

[[ ! -e ./.clojure ]] && mkdir ~/.clojure

[[ ! -e ./.clojure/deps.edn ]] &&  ln -s ~/homedir/.clojure/deps.edn ~/.clojure/deps.edn

[[ ! -e ~/.config/termite/config  ]] && {
  mkdir -p ~/.config/termite
  ln -s ~/homedir/termite/config ~/.config/termite/config
}


[[ ! -e ./.gitignore-default ]] &&  ln -s ~/homedir/.gitignore-default ~/.gitignore-default
[[ ! -e ./.gitconfig ]] &&  ln -s ~/homedir/.gitconfig ~/.gitconfig
[[ ! -e ./.ackrc ]] &&  ln -s ~/homedir/.ackrc ~/.ackrc

if [[ ! -e $HOME/.datomic/dev-local.edn ]]; then
  mkdir -p ~/.datomic
  ln -s ~/homedir/dev-local.edn ~/.datomic/dev-local.edn
fi



[[ ! -e ./.config/sway ]] &&  mkdir -p ~/.config/sway
[[ ! -e ./.config/sway/config ]] &&  ln -s ~/homedir/config/sway/config ./.config/sway/config

if grep -Eqi 'Name="?Ubuntu"?' /etc/os-release
then
  echo "Config git for work laptop"
  git config --global user.email rafael.ferreira@nubank.com.br
  git config --global user.name "Rafael de F. Ferreira"
else
  echo "Config git for personal  laptop"
  git config --global user.email rafael@rafaelferreira.net
  git config --global user.name "Rafael de F. Ferreira"
fi
	
git config --global push.default upstream
git config --global core.excludesFile ~/.gitignore-default


