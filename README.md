# _nixos

https://www.youtube.com/watch?v=Dy3KHMuDNS8&t=803s
homemanager 
https://youtu.be/Dy3KHMuDNS8?t=483

// to add as a module
 nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
 nix-channel --update
 
 // imports = [ <home-manager/nixos> ];

rolbacks
home-manager generations

# to force a configuration
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix






# bin
https://starship.rs

check out this wayland wm   
https://github.com/hyprwm/Hyprland

https://github.com/hyprwm/Hyprland/tree/main/hyprctl

https://github.com/notusknot?tab=repositories




# tips snippets


4.1. Automatic Upgrades

You can keep a NixOS system up-to-date automatically by adding the following to configuration.nix:

system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = true;




users.users.<name?>.hashedPassword
           Specifies the hashed password for the user. The options hashedPassword, password and passwordFile controls what password is set for the
           user.  hashedPassword overrides both password and passwordFile.  password overrides passwordFile. ***If none of these three options are
           set, no password is assigned to the user, and the user will not be able to do password logins.*** If the option users.mutableUsers is
           true, the password defined in one of the three options will only be set when the user is created for the first time. After that, you
           are free to change the password with the ordinary user management commands. If users.mutableUsers is false, you cannot change user
           passwords, they will always be set according to the password options.

           To generate hashed password install mkpasswd package and run mkpasswd -m sha-512.

           Type: null or string

           Default: null

           Declared by:
               <nixpkgs/nixos/modules/config/users-groups.nix>




dotfiles
https://discourse.nixos.org/t/how-to-manage-my-dotfiles/16608/2



filesystem
zfs
https://github.com/zfsonlinux/zfs-auto-snapshot