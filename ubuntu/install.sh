#! /usr/bin/env bash
GDM_XSESSIONS_DIR="/usr/share/xsessions/"
sudo cp ./ubuntu/default.desktop $GDM_XSESSIONS_DIR

sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 cargo
cargo install alacritty 

cat << 'EOF' >> $HOME/.profile

# Source home-manager init script
if [ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# Add cargo local bin to PATH (for, e.g., alacritty)
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi


EOF

