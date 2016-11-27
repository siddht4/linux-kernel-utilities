# How to use PROFILES 
## Desired Result:
To fully automate the kernel compilation process by entering a single command to the point of having created an installable set of `.deb` packages while allowing the use of a specific kernel configuration.

`./compile_linux_kernel.sh --profile=zeus`

## Approach:
By using a small stub script (`xprofile`), we can predefine the necessary variables in a *profile* that in effect replaces any necessary keyboard entry. In addition, as this is simply a **sourced** file, any desired pre- and post-executing hooks may be added.
## Template:
Let's examine the [zeus](./zeus) *profile* included in the [profiles](../profiles) directory: 
#### Code
```
1  . ./profiles/xprofile
2
3  zeus(){
4	USE_LATEST=1
5	KRNL_CONFIG=olddefconfig
6	KEY_HANDLER=add
7	QT5CHECK=0
8
9	xprofile
10 }
```
Those familiar with `bash` will identify this as a simple **function** definition.

#### Breakdown
| Line | Command | Info | Required |
| :--- | :------ | :--- | -------- |
| 0 | non-existent | There is no `#/bin/bash` to protect against accidental invocations |
| 1 | `. ./profiles/xprofile` | Sources the `xprofile` stub script | &#10004; |
| 3 | `zeus(){` | Name of the *profile* followed immediately by `(){` | &#10004; |
| 4 | `USE_LATEST=1` | Sets the invocation to download the latest kernel | &#10004; |
| 5 | `KRNL_CONFIG=olddefconfig` | Set the compilation config to use the current config as a baseline without prompts | &#10004; |
| 6 | `KEY_HANDLER=add` | How to handle unknown **GPG** keys
| 7 | `QT5CHECK=0` | Skip check for QT dependency
| 9 | `xprofile` | Executes stub script with assigned variables | &#10004; |
| 10 | `}` | Closing function brace | &#10004; |

#### Notes
- *Profile* files must be in the `profiles` directory
- Function name and profile file name must be the same (eg `zeus` on line 3)
- Usable with `latest` autodetection or a manually provided local kernel archive (Line 4)
- You can use the current machine's profile as shown, or you could adapt the script to use a previously saved kernel configuration file (Line 5) [Reference](https://www.kernel.org/doc/linux/README)
- For automation, we allow the automatic installation of new GPG keys (optional)
- For automation, we disable any check for QT5 dependency as it isn't used and may prompt the user