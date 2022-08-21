#!/bin/sh

pushd ~/_nixos/dotfiles
home-manager switch -f ./users/spaceface/home.nix
popd
