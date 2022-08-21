// https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
// 


mkdir -p /mnt


# Partition the disk
printf "label: gpt\n,550M,U\n,,L\n" | sfdisk /dev/sdg

mkfs.fat -F 32 /dev/sdg1
mkfs.btrfs -f /dev/sdg2

mount /dev/sdg2 /mnt

# We first create the subvolumes outlined above:
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/swap

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank



umount /mnt



///////////////////////////////////////////////
# Mount the partitions and subvolumes

mount -o compress=zstd,subvol=root /dev/sdg2 /mnt
mkdir /mnt/{home,nix}
mount -o compress=zstd,subvol=home /dev/sdg2 /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/sdg2 /mnt/nix
mount -o subvol=swap /dev/sdg2 /swap



mkdir /mnt/boot
mount /dev/sdg1 /mnt/boot



























