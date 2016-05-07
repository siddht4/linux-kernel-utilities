![Project Status: Active](https://img.shields.io/badge/project-active-green.svg)
[![Internal Build Status](https://git.marktompkins.me/mtompkins/linux-kernel-utilities/badges/master/build.svg)](https://git.marktompkins.me/mtompkins/linux-kernel-utilities) [![External Build Status](https://travis-ci.org/mtompkins/linux-kernel-utilities.svg?branch=master)](https://travis-ci.org/mtompkins/linux-kernel-utilities)
<img align="right" src="https://www.kernel.org/theme/images/logos/tux.png" alt="Linux Logo" title="Tux">
# Linux Kernel Utilities
## Descriptions

### Compile a kernel from source: `compile_linux_kernel.sh`
#### For use with Debian and derivatives (e.g. Ubuntu, LinuxMint, etc.)
Bash script that will poll http://www.kernel.org for available kernels and present the user with an xconfig GUI for manually selecting options. This script will also check the downloaded archive against the PGP signature file.    

**Note:** The user **MUST** save a configuration from the GUI even if defaults are used.    
The configuration routine will pull the current machine's configuration in to the utility as a base.

[See it on Youtube](https://www.youtube.com/watch?v=-6d9RJbR6_U)

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
    chmod 550 compile_linux_kernel.sh remove_old_kernels.sh update_ubuntu_kernel.sh

### Compile
To compile a kernel with manual version selection

    ./compile_linux_kernel.sh

To compile the latest kernel available

    ./compile_linux_kernel.sh latest

To compile a kernel from a local archive file

    ./compile_linux_kernel.sh linux-4.5.2.tar.xz

### Pre-compiled Ubuntu (and derivatives)
To download and install a precompiled Ubuntu kernel from [kernel.ubuntu.com](https://kernel.ubuntu.com)

    ./update_ubuntu_kernel.sh

To download and install the latest precompiled Ubuntu kernel from [kernel.ubuntu.com](https://kernel.ubuntu.com)

    ./update_ubuntu_kernel.sh latest

### Removal of inactive kernels
To remove ALL non-active kernels

    ./remove_old_kernels.sh

## Notes
> Do not run the scripts with `sudo`. They will prompt for elevated priviledges if necessary. The user must be a **member of the sudo group** however.
>
> Some older kernels (e.g. 3.x) require earlier versions of QT. If errors are thrown during the kernel configuration process, look for errors indicating a version of QT is not installed. If so, manually install the required version and rerun the script.    
>### CI & Unit Testing
> Internal: Gitlab & Gitlab CI    
> External: Github & Travis CI    
> [BATS](https://github.com/sstephenson/bats)
>### TIPS
>- You can set `RC_FILTER` to control whether Release Candidates are offered as a choice.
>- Enlarge your terminal window prior to executing the scripts to ensure proper formatting of available choices.    
>- Multicore compiling is set automatically with `CONCURRENCY_LEVEL` to a number determined for the system. This can be manually adjusted in the [variables](./variables) file.
>
>[Google](https://www.google.com/?gws_rd=ssl#q=concurrency%20level%20make-kpkg) is your friend.
