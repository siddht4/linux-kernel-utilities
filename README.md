![Project Status: Active](https://img.shields.io/badge/project-active-green.svg)
[![Internal Build Status](https://git.marktompkins.me/mtompkins/linux-kernel-utilities/badges/master/build.svg)](https://git.marktompkins.me/mtompkins/linux-kernel-utilities) [![External Build Status](https://travis-ci.org/mtompkins/linux-kernel-utilities.svg?branch=master)](https://travis-ci.org/mtompkins/linux-kernel-utilities) [![Issue Count](https://codeclimate.com/github/mtompkins/linux-kernel-utilities/badges/issue_count.svg)](https://codeclimate.com/github/mtompkins/linux-kernel-utilities)
<img align="right" src="img/tux.png" alt="Linux Logo" title="Tux">
# Linux Kernel Utilities
## Descriptions

### Compile a kernel from source: `compile_linux_kernel.sh`
#### For use with Debian and derivatives (e.g. Ubuntu, LinuxMint, etc.)
Bash script that will poll http://www.kernel.org for available kernels and present the user with an xconfig GUI for manually selecting options. This script will also check the downloaded archive against the PGP signature file.    

**Note:** The user **MUST** save a configuration from the GUI even if defaults are used.    
The configuration routine will pull the current machine's configuration in to the utility as a base.

----
### Download precompiled Ubuntu kernel: `update_ubuntu_kernel.sh`
Bash script that will poll https://kernel.ubuntu.com for available precompiled kernels and present the user with a menu for selection.
It is set to currently filter for kernels at v4. Both **generic** and **lowlatency** choices are provided.    

This is intended explicitly for **Ubuntu** and derivatives like **linuxMint**.

----
### Remove all inactive kernels: `remove_old_kernels.sh`
Bash script that will purge **ALL** inactive kernels.    

This may not be prudent for some as this will leave no default / backup safety kernel. The only kernel that will remain is the currently loaded version. It is highly recommended that a reboot be performed before executing this script.

----
## Usage
Download and enable scripts

    git clone https://github.com/mtompkins/linux-kernel-utilities.git
    cd linux-kernel-utilities
    chmod 750 compile_linux_kernel.sh remove_old_kernels.sh update_ubuntu_kernel.sh

### Compile
To compile a kernel with manual version selection

    ./compile_linux_kernel.sh

To compile the latest kernel available
<a href="https://www.youtube.com/watch?v=Us88qzNL3oI" target="_blank"><img src="img/youtube.png" /></a>

    ./compile_linux_kernel.sh latest

To compile a kernel from a local archive file

    ./compile_linux_kernel.sh linux-4.5.2.tar.xz

To compile the latest kernel *automagically* using a profile

    ./compile_linux_kernel.sh zeus

### Precompiled Ubuntu (and derivatives)
To download and install a precompiled Ubuntu kernel from [kernel.ubuntu.com](https://kernel.ubuntu.com)

    ./update_ubuntu_kernel.sh

To download and install the latest precompiled Ubuntu kernel from [kernel.ubuntu.com](https://kernel.ubuntu.com)
<a href="https://www.youtube.com/watch?v=CokrHUykkUQ" target="_blank"><img src="img/youtube.png" /></a>

    ./update_ubuntu_kernel.sh latest

### Removal of inactive kernels
To remove ALL non-active kernels

    ./remove_old_kernels.sh

## Notes
> Do not run the scripts with `sudo`. They will prompt for elevated privileges if necessary.     
>
> Some older kernels (e.g. 3.x) require earlier versions of QT. If you are building v3.x kernels you should manually install QT4 before compiling. The script is set to install QT5 if missing.
>### Kernel Source Preservation
> When installing a compiled kernel, links are created to the kernel source so that `DKMS` will function correctly. Therefore, you should take care not to delete the `Build_xxxx` folders after installation. If you compile a newer release and remove an older kernel using `dpkg -r`, it is then safe to delete the entire directory of the removed kernel version.
>### CI & Unit Testing
> Internal: Gitlab & Gitlab CI    
> External: Github & Travis CI    
> [BATS](https://github.com/sstephenson/bats)
>### TIPS
>- You can set `RC_FILTER` to control whether Release Candidates are offered as a choice.
>- Enlarge your terminal window before executing the scripts to make sure proper formatting of available choices.    
>- Multicore thread compiling is set automatically to twice the amount of detected cores.
>- Consider temporarily increasing `grub` menu timeouts and / or unhiding in case the new kernel is problematic.

## CRISIS - cannot boot properly after new kernel is installed
>- If all else fails and a new kernel prevents you from booting you can:
>   - Boot to a linux based LiveCD (e.g. [GParted](http://gparted.org/download.php) on a USB)
>   - Open Terminal
>   - Mount the partition: `sudo mount /dev/sdXY /mnt`     
>       where **sdXY** is likely your `sda1`
>   -   Mount some special partitions:
``` 
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
```
>   - Chroot into the /mnt: `sudo chroot /mnt`
>   - Remove the kernel packages you just installed with `dpkg -r yourRecentKernels`
>       - They must be removed in a non-dependency order, so just take your time.
>       - `dpkg --list | grep "ii[[:space:]][[:space:]]linux-[f,h,i,l]"`   
           will help list your installs
>   - Buy me a beer through PayPal
