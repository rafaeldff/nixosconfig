#! /usr/bin/env bash
set -e

HOST="$1"
NIX_FILES=$(ls ./*.nix | grep -v configuration)
PATCH_FILES=$(ls ./*.patch | grep -v configuration)
CONFIG_FILE="./configuration-${HOST}.nix"

cp $NIX_FILES /etc/nixos/
cp $PATCH_FILES /etc/nixos/
cp $CONFIG_FILE /etc/nixos/configuration.nix
