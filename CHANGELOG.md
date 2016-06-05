# linux-kernel-utilities Changelog

## v1.0.4 (Jun 4, 2016)
NEW FEATURES
- Add version check
- Add version function for feedback (-v or --version)

IMPROVEMENTS
- Add `post-commit` created `version` file to aid user in determining current status against repo
- Update `README.md` with baseline process of removing a defective kernel

FIXES
- none

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.3 (Jun 3, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- none

FIXES
- Correct update function 
    - remove noninteractive environment setting
- Correct compilation by profile install feedback

DEPRECATED
- Remove `make-kpkg` dependencies 

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.2 (Jun 1, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- Modify update function to give improved feedback
- Limit update function to install missing packages instead of all dependencies

FIXES
- Set TERM environment on gitlab-ci

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.1 (May 29, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- Addition of CodeClimate
- Use of tput colors

FIXES
- Migration from older `make-kpkg` to `make deb-pkg`
- Proper handling of locally passed kernel archive file
- Suppress background spinner stop feedback

DEPRECATED
- Use of `make-kpkg`
- ANSI colors

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.0 (May 19, 2016)
NEW FEATURES
- Added ability to compile by profile for fully automatic compiling.

IMPROVEMENTS
- CI now tests on both Ubuntu and Debian

FIXES
- Update CHANGELOG.md `FIXES` not to conflict with CodeClimate scans

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO

## v0.1.0 (May 1, 2016)
NEW FEATURES
- Added ability to automate selecting most recent kernel with `./compile_linux_kernel.sh latest`
- Added ability to automate selecting most recent precompiled kernel with `./update_ubuntu_kernel.sh latest`

IMPROVEMENTS
- Additional README.md instructions
- BATS unit testing

FIXES
- none

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Create usage feedback
