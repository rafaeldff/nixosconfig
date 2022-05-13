#! /usr/bin/env bash
set -e

HOST="$1"
NIX_FILES=$(ls ./*.nix | grep -v configuration)
CONFIG_FILE="./configuration-${HOST}.nix"

cp $NIX_FILES /etc/nixos/
cp -R ./home /etc/nixos/
cp $CONFIG_FILE /etc/nixos/configuration.nix
