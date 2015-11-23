#! /usr/bin/env bash

cp $HOME/scripts/setuphome.sh ./
cp /home/rafael/dev/nu/nudev/setupnu.sh ./
cp /etc/nixos/configuration.nix ./

git commit -m "Updated nixos setup" -- setuphome.sh configuration.nix setupnu.sh


