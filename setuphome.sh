#!  /usr/bin/env bash
set -x
cd $HOME

[[ ! -e ./homedir ]] && git clone Dropbox/homedir homedir

[[ ! -e ./.xmonad ]] &&  mkdir ~/.xmonad

[[ ! -e ./.xmonad/xmonad.hs  ]] && ln -s ~/homedir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs

[[ ! -e ./.local/share/fonts  ]] && ln -s ~/homedir/.fonts ~/.local/share/fonts

[[ ! -e ./temp ]] &&  mkdir ~/temp

[[ ! -e ./bin ]] &&  ln -s ~/homedir/bin ~/bin

if [[ ! -e ./.vim ]] ; then
  echo Setting up vim
  pushd homedir
  git submodule update --init --recursive
  popd
  pwd
  
  [[ ! -e ./.vim ]] &&  ln -s ~/homedir/.vim ~/.vim
  [[ ! -e ./.vimrc ]] &&  ln -s ~/homedir/.vim/vimrc ~/.vimrc
  [[ ! -e ./.gvimrc ]] &&  ln -s ~/homedir/.vim/gvimrc ~/.gvimrc
fi

git config --global user.email rafael@rafaelferreira.net
git config --global user.name "Rafael de F. Ferreira"

