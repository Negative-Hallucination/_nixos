{ pkgs, ... }:

with import <nixpkgs> { };
{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "voight-kampff";
  home.homeDirectory = "/home/voight-kampff";

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

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    nano
  ];
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };


  ## config in .config/git/config
  # programs.git = {
  #   enable = true;
  #   userName = "graphis";
  #   userEmail = "ezsolt@gmail.com";
  # };
  
  

}
