# DebOS — Debian yadrosidagi mini OS

Debian'ning rasmiy Linux yadrosi (`linux-image-amd64`) + busybox'dan iborat initramfs-asosli OS.

```bash
sudo apt install python3 dpkg cpio gzip qemu-system-x86 grub-pc-bin xorriso mtools
./build.sh      # build/vmlinuz, build/initramfs.gz (va debos.iso)
./run.sh        # QEMU'da ishga tushirish
```
Fayllar: `fetch_debs.py` (Debian'dan yuklash), `rootfs-overlay/init` (birinchi jarayon), `build.sh`, `run.sh`.
