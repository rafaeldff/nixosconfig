#! /usr/bin/env bash

cp $HOME/scripts/setuphome.sh ./
cp /etc/nixos/configuration.nix ./

git commit -m "Updated nixos setup" -- setuphome.sh configuration.nix


