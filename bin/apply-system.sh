#!/bin/sh

pushd ~/_nixos/dotfiles
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
