#!/usr/bin/env bash
# Debian yadrosi + busybox asosida minimal OS (initramfs) yig'adi.
# Kerak: python3, dpkg-deb (dpkg), cpio, gzip. ISO uchun: grub-mkrescue, xorriso.
set -euo pipefail
cd "$(dirname "$0")"
B=build; rm -rf "$B/root"; mkdir -p "$B/debs" "$B/root"/{bin,sbin,etc,proc,sys,dev,tmp,run,root,usr/bin,usr/sbin}

[ -n "$(ls "$B/debs" 2>/dev/null)" ] || python3 fetch_debs.py "$B/debs"

# Yadroni chiqarish
mkdir -p "$B/kernel"
dpkg-deb -x "$B"/debs/linux-image-*.deb "$B/kernel"
cp "$B"/kernel/boot/vmlinuz-* "$B/vmlinuz"

# busybox
mkdir -p "$B/bb"; dpkg-deb -x "$B/debs/busybox-static.deb" "$B/bb"
cp "$B/bb/bin/busybox" "$B/root/bin/busybox"

cp -r rootfs-overlay/. "$B/root/"
chmod +x "$B/root/init"

( cd "$B/root" && find . | cpio -o -H newc --quiet | gzip -9 ) > "$B/initramfs.gz"
echo "Tayyor: $B/vmlinuz + $B/initramfs.gz"

if command -v grub-mkrescue >/dev/null; then
  mkdir -p "$B/iso/boot/grub"
  cp "$B/vmlinuz" "$B/initramfs.gz" "$B/iso/boot/"
  cat > "$B/iso/boot/grub/grub.cfg" <<G
set timeout=2
menuentry "DebOS" { linux /boot/vmlinuz console=tty0 console=ttyS0 quiet; initrd /boot/initramfs.gz; }
G
  grub-mkrescue -o debos.iso "$B/iso" 2>/dev/null && echo "ISO: debos.iso"
fi
