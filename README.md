# Linux Kernel Compilation Utilities
##compile_linux_kernel.sh
Bash script that will poll http://www.kernel.org for available kernels and present the user with an xconfig GUI for manually sellecting options.

**Note: ** The user *MUST* save a configuration from the GUI even if defaults are used. The configuration routine will pull the current machine's configuration in to the utility as a base.

##remove_old_kernels.sh##
Bash script that will purge **ALL** inactive kernels. This may not purdent for some as this will leave no default / backup safety kernel. Some of us live on the edge. It is highly recommended that a simple reboot be performed before executing this script.