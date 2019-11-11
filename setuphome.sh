#!  /usr/bin/env bash
IDEA="ideaIC-15.0.1"
set -x
shopt -s nullglob
cd $HOME

[[ ! -e ./homedir ]] && git clone Dropbox/homedir homedir

[[ ! -e ./.bashrc ]] && ln -s ~/homedir/.bashrc ~/.bashrc

[[ ! -e ./.xmonad ]] &&  mkdir ~/.xmonad

[[ ! -e ./.xmonad/xmonad.hs  ]] && ln -s ~/homedir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs

[[ ! -e ~/.config/xmobar/xmobarrc  ]] && {
  mkdir -p ~/.config/xmobar 
  ln -s ~/homedir/xmobarrc ~/.config/xmobar/xmobarrc
} 

[[ ! -e ./.local/share/fonts  ]] && ln -s ~/homedir/.fonts ~/.local/share/fonts

[[ ! -e ./temp ]] &&  mkdir ~/temp

if [[ ! -e ./apps/java/jdk8 ]]; then
 if test -n "echo ./Downloads/jdk-8*.tar.gz" ; then
   mkdir -p ./apps/java
   tar -C ./apps/java/ -xzf ./Downloads/jdk-8*.tar.gz
   ln -s $HOME/apps/java/jdk1.8.0_* $HOME/apps/java/jdk8
 fi
fi

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

#if [[ ! -e ./apps/idea ]]; then
  #IDEA_FILE="ideaIC-15.0.1.tar.gz"
  #IDEA_URI="https://d1opms6zj7jotq.cloudfront.net/idea/${IDEA_FILE}"

  #mkdir -p ./apps/idea
  #[[ ! -e /tmp/$IDEA_FILE ]] && wget $IDEA_URI -o /tmp/$IDEA_FILE
  #tar -C ./apps/idea/ -xzf $IDEA_FILE
  #IDEA_VER=$(ls -1td $HOME/apps/idea/* | head -1)
  #unlink ./apps/idea/current || true
  #ln -s $IDEA_VER $HOME/apps/idea/current
#fi

[[ ! -e ./.gitignore-default ]] &&  ln -s ~/homedir/.gitignore-default ~/.gitignore-default
[[ ! -e ./.gitconfig ]] &&  ln -s ~/homedir/.gitconfig ~/.gitconfig

#if [[ ! -e ./apps/hub/current ]]; then
  #HUB_FILE="hub-linux-amd64-2.2.2.tgz"
  #HUB_URI="https://github.com/github/hub/releases/download/v2.2.2/${HUB_FILE}"

  #mkdir -p ./apps/hub
  #[[ ! -e /tmp/$HUB_FILE ]] && wget $HUB_URI -o /tmp/$HUB_FILE
  #tar -C ./apps/hub/ -xzf $HUB_FILE
  #HUB_VER=$(ls -1td $HOME/apps/hub/* | head -1)
  #unlink ./apps/hub/current || true
  #ln -s $HUB_VER $HOME/apps/hub/current
  #[[ ! -e $HOME/bin/hub  ]] && ln -s $HOME/apps/hub/current/bin/hub $HOME/bin/hub
#fi

git config --global user.email rafael@rafaelferreira.net
git config --global user.name "Rafael de F. Ferreira"
git config --global push.default upstream
git config --global core.excludesFile ~/.gitignore-default

