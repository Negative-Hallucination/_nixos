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

  #echo "drive: ${drive}"
  #echo "device: ${device}"



  print_error "Wiping out all the data and signatures of the choosen disk (${device})..."
  wipefs --all -f "${device}"

  print_info "Done!"
  print_info "Starting partitioning of ${device} ..."



  mkdir -p /mnt

  # Partition the disk
  printf "label: gpt\n,550M,U\n,,L\n" | sfdisk "${device}"

  print_info "────────────────────── creating efi partition "
  bootdevice="/dev/${drive}1"
  mkfs.fat -F 32 "${bootdevice}"

  echo "────────────────────── creating btrfs partition "
  btrfsdevice="/dev/${drive}2"
  mkfs.btrfs -f "${btrfsdevice}"

  mount "${btrfsdevice}" /mnt

  # We first create the subvolumes outlined above:
  echo "────────────────────── creating subvolumes "
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/home
  btrfs subvolume create /mnt/nix
  btrfs subvolume create /mnt/swap

  # We then take an empty *readonly* snapshot of the root subvolume,
  # which we'll eventually rollback to on every boot.
  echo "────────────────────── creating subvolumes "
  btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

  umount /mnt


  # Mount the partitions and subvolumes
  echo "────────────────────── mounting disks "
  mount -o compress=zstd,subvol=root "${btrfsdevice}" /mnt
  mkdir /mnt/{home,nix}
  mount -o compress=zstd,subvol=home "${btrfsdevice}" /mnt/home
  mount -o compress=zstd,noatime,subvol=nix "${btrfsdevice}" /mnt/nix
  mount -o subvol=swap "${btrfsdevice}" /swap

  mkdir /mnt/boot
  mount "${bootdevice}" /mnt/boot


  print_info "Done!"
  nixos-generate-config --root /mnt


  nixos-install




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




