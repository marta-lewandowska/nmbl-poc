#!/bin/bash

root_args=""

check_lvm () {
    lsblk -f | grep "LVM" > /dev/null 2>&1
}

set_lvm () {
    root=$(mount | grep " / " | awk '{print $1}')
    rd_lvm_lv=$(grep -oP '(?<=rd.lvm.lv=)[^ ]*' /proc/cmdline)
    root_args="root=$root ro rd.lvm.lv=$rd_lvm_lv"
}

check_btrfs () {
    fs=$(lsblk -f | grep "$(awk '/ \/ / {print $1}' /etc/fstab | grep -oP '(?<=UUID=)[^ ]*')" | awk '{print $2}')
    if [[ "$fs" == "btrfs" ]]; then
            set_btrfs
    fi
}

set_btrfs () {
    root=$(grep -oP '(?<=root=)[^ ]*' /proc/cmdline)
    rootflags=$(grep -oP '(?<=rootflags=)[^ ]*' /proc/cmdline)
    root_args="root=$root ro rootflags=$rootflags"
}

set_standard () {
    root=$(grep -oP '(?<=root=)[^ ]*' /proc/cmdline)
    root_args="root=$root ro"
}

if check_lvm; then
    set_lvm
fi

check_btrfs
if [[ -z $root_args ]]; then
    set_standard
fi

idex=$(efibootmgr | tail -n 1 | cut -d' ' -f1 | grep -o "[1-9]*")
idex=$(($idex+1))

echo -n "\nmbl-cloud.uki console=ttyS0 $(echo $root_args) boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.system.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 00$idex -C -d /dev/vda -p 1 -L nmbl_switch -l /EFI/fedora/shimx64.efi -@ - -n 00$idex
idex=$(($idex+1))
echo -n "\nmbl-megalith.uki console=ttyS0 $(echo $root_args) boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.system.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 00$idex -C -d /dev/vda -p 1 -L nmbl_mega -l /EFI/fedora/shimx64.efi -@ - -n 00$idex
idex=$(($idex+1))
echo -n "\nmbl-workstation.uki console=ttyS0 $(echo $root_args) boot=$(awk '/ \/boot / {print $1}' /etc/fstab) rd.system.gpt_auto=0" | iconv -f UTF8 -t UCS-2LE | efibootmgr -b 00$idex -C -d /dev/vda -p 1 -L nmbl_kexec -l /EFI/fedora/shimx64.efi -@ - -n 00$idex
