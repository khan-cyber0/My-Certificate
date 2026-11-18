#!/usr/bin/env bash
# QEMU'da ishga tushirish (chiqish: Ctrl+A, keyin X)
cd "$(dirname "$0")"
exec qemu-system-x86_64 -m 512 -nographic \
  -kernel build/vmlinuz -initrd build/initramfs.gz \
  -append "console=ttyS0 rdinit=/init"
