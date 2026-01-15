#!/bin/bash
# Kubuntu Live USB Mount & Chroot Prep Script (with arguments)
# Usage: ./mount-chroot.sh <ROOT_PARTITION> [BOOT_PARTITION]

# Check for root partition argument
if [ -z "$1" ]; then
    echo "Usage: $0 <ROOT_PARTITION> [BOOT_PARTITION]"
    echo "Example: $0 /dev/nvme0n1p2 /dev/nvme0n1p1"
    exit 1
fi

ROOT_PART=$1
BOOT_PART=$2   # Optional

# Mount root
echo "Mounting root partition $ROOT_PART ..."
sudo mount $ROOT_PART /mnt || { echo "Failed to mount root partition"; exit 1; }

# Mount boot if provided
if [ -n "$BOOT_PART" ]; then
    echo "Mounting boot partition $BOOT_PART ..."
    sudo mount $BOOT_PART /mnt/boot || { echo "Failed to mount boot partition"; exit 1; }
fi

# Mount pseudo-filesystems
echo "Mounting pseudo-filesystems..."
for fs in /dev /dev/pts /proc /sys /run; do
    sudo mount --bind $fs /mnt$fs || { echo "Failed to mount $fs"; exit 1; }
done

echo "All partitions and pseudo-filesystems mounted successfully."
echo "You can now chroot into the system with:"
echo "sudo chroot /mnt /bin/bash"
