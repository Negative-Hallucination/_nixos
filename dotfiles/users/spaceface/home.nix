{ pkgs, ... }:

with import <nixpkgs> { };
{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "spaceface";
  home.homeDirectory = "/home/spaceface";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    nano
    fish
    nnn

    # util
    gparted
    # starship

    # graphic apps
    blender

    # text
    obsidian
    geany
  ];
  

  
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
    add_newline = true;
      character = {
        success_symbol = " [>](bold green)";
        error_symbol = " [!](bold red)";
      };
      # package.disabled = true;
    };
  };
 



  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      ms-vscode-remote.remote-ssh
    ];
  };








  # config in .config/git/config
  programs.git = {
    enable = true;
    userName = "graphis";
    userEmail = "ezsolt@gmail.com";
  };



  # inputs.hyprland.homeManagerModules.default;
  # wayland.windowManager.hyprland.enable = true;


  

}
