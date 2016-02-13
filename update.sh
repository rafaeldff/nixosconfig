#! /usr/bin/env bash

cp $HOME/nixosconfig/setuphome.sh ./
cp $HOME/dev/nu/nudev/setupnu.sh ./
#cp /etc/nixos/configuration.nix ./
cp /etc/nixos/*.nix ./

git commit -m "Updated nixos setup" -- setuphome.sh configuration.nix setupnu.sh


