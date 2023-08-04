## Arch setup

Notes on setup + installation from a weekend dual-booting to Arch Linux.

---

What is Arch?
- x86-64 = Intel-based 8086 microprocessor instructions, compared to ARM which more lightweight (Reduced vs Complex instruction set architectures - but it gets complicated since ARM also creates x84 compatible chips), 64 bit instructoins
- Simple, lightweight; install all packages yourself
- Follows basic Linux file system hierarchy with systemd

What is UEFI?
- First have to understand bootloader, BIOS, and bootloading sequence
Power -> Hardware -> Bootloader (BIOS, hardware) -> Bootloader (OS) -> Kernel

- Booting is what happens from moment you press "power" button to login (on Linux, this is the wonderfully colored stream of text that appears!)
  - Program that does this is called bootloader

FIRST STAGE: BIOS/UEFI
- BIOS (Basic Input-Output System) looks for bootable device, finds it, and passes it along to next stage bootloader
  - Stored in beginning of ROM
  - Also gives basic instructions for peripheries (hence "input-output") and microprocessor
  - Early booting (UNIVAC) used punch cards, which would load into memory, then load a larger program (chain loading)

SECOND STAGE: GNU GRUB
- Bootloader looks for kernels on hard drive, loads into RAM, and eventually hands over control to OS
  - Kernel = bridge between software and hardware (ex. manage CPU, complete control over hardware) 
- GRUB = GRand Unified Bootloader

![GRUB on GPT-partition](https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/GNU_GRUB_on_GPT_partitioned_hard_disk_drives.svg/495px-GNU_GRUB_on_GPT_partitioned_hard_disk_drives.svg.png)

BIOS is old (only 16-bit, 1MB memory) so UEFI was created to replace it 
BIOS/MBR -> UEFI/GPT

---

Arch Install

Pre-installation steps:
1. shrink Windows disk (diskmgmt.msc > Shrink volume)
- shrank by 200000MB = 200 GB (around 50% of total capacity)
2. Download Arch Linux
3. Rufus to burn .iso into USB flash drive
- GPT/UEFI partitioning, FAT32
4. Boot menu (Advanced startup > restart > UEFI firmware - a lot more foolproof than spamming F12!)

Setting up Arch Linux: https://wiki.archlinux.org/title/Installation_guide
1. Partition disk (disks on Linux is the equivalent of C:, D: drives on Window; each has partitions, which can be formatted into volumes and used to access files)
- Useful commands: `free -h` to see free memory, `lsblk` or `fdisk -l` to see disks (I had /dev/sda, /dev/nvme0n1), `cfdisk` or `gdisk` /dev/nvme0n1 (different interfaces to create partitions)
- cfdisk said I had 196GB of free space (which is expected from 200GB allocated earlier)
  - Created swap and root partitions
  swap = size of memory (free says I have 11GB so I allocated +10G swap), /dev/nvme0n1p6
  root = rest of unalloc space (185.3GB), /dev/nvme0n1p7

`free -h`:
First 4 sectors are partition table (2048 = 4x512)
  1 = Master Boot Record (MBR), 2 = GPT Header, 3/4 = partitions
Then /dev/nvme0n1p1 is EFI system for booting ... etc to nvme0n1p7 file system

What is swap? What does creating a separate partition (Ex. for /home) do? What is nvme0n1 vs sda?
- Block devices are interfaces to hard drives (can r/w a block at a time to storage), SCSI and NVMe are types
  - NVMe are a faster type ex. parallelization, often used with SSDs (instead o HDDs)
- Linux divides RAM into chunks called "pages" which can be"swapped" in when mem runs out. Basically, kernel keeps track of what's in use in pages, and frees up memory by copying from cache/RAM to swap space on the hard disk
  - total memory = RAM + swap

2. Format/mount partitions
Swap -> [SWAP]
- `free -m` to verify
Root -> /mnt
- Create ext4 file system (type of file system for linux)
EFI -> /mnt/boot
- mount /dev/nvme0n1p1 (already has EFI)

3. Update mirrorlist and install packages using pacstrap

4. Configure the system
- fstab to generate definitions for partitions (which don't by default get saved after reboot) and let kernel know what to mount
- cat /mnt/etc/fstab to verify
- change root to new system using arch-chroot /mnt

5. Grub install
- `grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck`
- Generate main config for grub: `grub-mkconfig -o /boot/grub/grub.cfg`
  - adds menu entries for the kernel so we can choose which to boot up
  - allow it to detect windows by using os_prober
- Verify: `ls /boot/efi/EFI` to see all the boot menu entries (includes Windows) and `ls /boot/efi/EFI/grub_uefi` to make sure grubx64.efi is present

6. Add user, Install necessary packages, then reboot and watch it come to life!
pacman = PACkage MANager!
nmtui = network manager UI, connect to wifi (MAKE SURE TO ENABLE SERVICE)
dhcpd = get IP address
intel-ucode = microcode
xorg (display server) + kde plasma + wayland (desktop/graphical interface, add drm to grub file for nvidia https://community.kde.org/Plasma/Wayland/Nvidia)
+ some other Intel video cards, audio, etc

Update 8/3/23 (allocate full disk to arch):

Unlike dual boot, we can delete all of the partitions and completely reinstall EFI too

    Mount EFI to /boot/efi is better than /boot!

Make sure mkinitcpio -P runs properly (can find linux image), and grub generation can too (initially was in /boot/efi instead of /boot, moved files over)
Xorg + plasma

---

env:
- konsole, zsh, ohmyzsh, powerlevel10k theme (faster with git; use lean not pure!)
- i3 for tiling manager (https://github.com/heckelson/i3-and-kde-plasma USE OPTION 2)
- deep learning: `sudo pacman -S nvidia nvidia-utils cuda cudnn`
- misc: flameshot (screen capture), feh (image viewer/bg), gvim (for copypaste vim)

---

additional resources:
https://gist.github.com/Pamblam/99ef7b1f3c4f0f1526692ee4ea07d957
https://www.freecodecamp.org/news/how-to-install-arch-linux/#how-to-generate-the-fstab-file

---

Arch you glad you made the switch to Arch?
(…sorry :P)

