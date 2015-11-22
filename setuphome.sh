#!  /usr/bin/env bash
IDEA="ideaIC-15.0.1"
set -x
cd $HOME

[[ ! -e ./homedir ]] && git clone Dropbox/homedir homedir

[[ ! -e ./.xmonad ]] &&  mkdir ~/.xmonad

[[ ! -e ./.xmonad/xmonad.hs  ]] && ln -s ~/homedir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs

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
fi

if [[ ! -e ./apps/idea ]]; then
  IDEA_FILE="ideaIC-15.0.1.tar.gz"
  IDEA_URI="https://d1opms6zj7jotq.cloudfront.net/idea/${IDEA_FILE}"

  mkdir -p ./apps/idea
  [[ ! -e /tmp/$IDEA_FILE ]] && wget $IDEA_URI -o /tmp/$IDEA_FILE
  tar -C ./apps/idea/ -xzf $IDEA_FILE
  IDEA_VER=$(ls -1td $HOME/apps/idea/* | head -1)
  unlink ./apps/idea/current || true
  ln -s $IDEA_VER $HOME/apps/idea/current
fi

[[ ! -e ./.bashrc ]] &&  ln -s ~/homedir/.bashrc ~/.bashrc

git config --global user.email rafael@rafaelferreira.net
git config --global user.name "Rafael de F. Ferreira"
git config --global push.default upstream

