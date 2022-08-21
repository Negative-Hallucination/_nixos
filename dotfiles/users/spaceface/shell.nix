
let 
  pkgs = import <nixpkgs> {};
  nixos-generators = import (builtins.fetchTarball https://github.com/nix-community/nixos-generators/archive/master.tar.gz);

in with pkgs;
mkShell {

  nativeBuildInputs = [
    direnv
    niv
    nixos-generators
  ];

  NIX_ENFORCE_PURITY = true;

  shellHook = ''
    echo "Hello shell"
    export SOME_API_TOKEN="$(cat ~/.config/some-app/api-token)"
  '';

}

