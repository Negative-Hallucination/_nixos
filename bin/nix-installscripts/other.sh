# Display NixOS Help - Very important ! 
$ nixos-help  

# use the root user
$ sudo -i

# Change the keyboard in French (Optional of course)
$ loadkeys fr

# Display disk partition
$ lsblk  

# open parted tool and then free 2GB for the SWAP 
$ parted /dev/sda -- mklabel gpt  
$ parted /dev/sda -- mkpart primary 512MiB -2GiB  
$ parted /dev/sda -- mkpart primary -2GiB 100%  

# Create ESP partition
$ parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB  
$ parted /dev/sda -- set 3 boot on  

# LUKS Encryption
$ cryptsetup luksFormat /dev/sda1
$ cryptsetup luksOpen /dev/sda1 nixos-root

# Check if you luks is setup before the next part (nixos-root)
$ ls -l /dev/mapper

# BTRFS
mkfs.btrfs -L nixroot /dev/mapper/nixos-root

# Init the SWAP
$ mkswap /dev/sda2
$ swapon /dev/sda2

# Check free space
$ free -hm

# Create the BOOT partition
$ mkfs.vfat -n BOOT /dev/sda3

# Mount nixos-root into /mnt
$ mount -t btrfs /dev/mapper/nixos-root /mnt

# Create subvolume btrfs
$ btrfs subvolume create /mnt/nixos
$ btrfs subvolume list /mnt

# Unmount /mnt & mount nix-root uing btrfs option
$ umount /mnt
$ mount -t btrfs -o subvol=nixos /dev/mapper/nixos-root /mnt
$ cd /mnt
$ ls

# Create BTRFS subvolume
$ btrfs subvolume create /mnt/home
$ btrfs subvolume create /mnt/var
$ btrfs subvolume create /mnt/nix
$ btrfs subvolume list /mnt
$ mkdir /mnt/boot

# mount BOOT into /mnt/boot
$ mount /dev/sda3 /mnt/boot
$ ls -l /mnt

# Init the configuration of your setup
$ nixos-generate-config --root /mnt

# Install !
$ nixos-install