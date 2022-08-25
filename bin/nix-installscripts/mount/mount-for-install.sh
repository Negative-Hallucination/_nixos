#!/usr/bin/env bash

set -e # exit immediately if a command return non-zero status
usage() {
  echo "This script create 2 partition:"
  echo
  echo "
   DISK
   |
   ├── EFI (boot partition, fat32, 512MiB)
   |
   └── System (system partition, BTRFS, rest of the disk)
   |
   └── root / home - nix - swap
"
  echo "Options"
  echo "  -h, --help    prints this message and exits"
  echo "  -s, --start   start the installation"
  echo "   *            print this menu"
  exit 1
}

print_ok() {
    printf "\e[32m%b\e[0m" "$1"
    printf "\n"
}

print_info() {
    printf "\e[36m%b\e[0m" "$1"
    printf "\n"
}

print_error() {
    printf "\e[31m%b\e[0m" "$1"
    printf "\n"
}


installation(){

  if [[ $EUID -ne 0 ]]; then
    print_error "This scripts needs to be runned as root!"
    exit 1
  fi

  read -p "nvme or sdX: " -r
  
  drive=$REPLY
  device="/dev/${drive}"


  mkdir -p /mnt

  btrfsdevice="/dev/${drive}2"



  echo "────────────────────── mounting disks "
  mount -o compress=zstd,subvol=root /dev/sdb2 /mnt
  mount -o compress=zstd,subvol=home /dev/sdb2 /mnt/home
  mount -o compress=zstd,noatime,subvol=nix /dev/sdb2 /mnt/nix
  mount -o subvol=swap /dev/sdb2 /swap

  mkdir -p /mnt/boot
  mount "${bootdevice}" /mnt/boot


  print_info "Done!"
  nixos-generate-config --root /mnt




}


umount() {
  umount /boot
  umount /home
  umount /nix
  umount /mnt
}





if [ $# -eq 0  ]
then
        usage
        exit
fi


case "$1" in
    "-h" | "--help") usage ;;
    "-s" | "--start") installation ;;
    "-u" | "--umount") umount ;;
    *) echo "DEFAULT"
esac




