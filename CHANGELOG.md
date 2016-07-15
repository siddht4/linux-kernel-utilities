# linux-kernel-utilities Changelog

## v1.0.8 (Jul 15, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- Replace `err=$?` with `${PIPESTATUS[0]}` on piped `wget`

FIXES
- Improve / correct Ubuntu precompiled URL detection

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.7 (Jul 14, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- none

FIXES
- Improve / correct Ubuntu precompiled URL detection

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`
- Improve failed download detection

## v1.0.6 (Jun 21, 2016)
NEW FEATURES
- none

IMPROVEMENTS
- none

FIXES
- Add `bc` to required packages

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

## v1.0.5 (Jun 7, 2016)
NEW FEATURES
- Enable remote compilation using ncurses

IMPROVEMENTS
- Script will detect a remote session and change to ncurses programmatically

FIXES
- none

DEPRECATED
- none

WORK IN PROCESS
- none

TO DO
- Update unit tests for `make deb-pkg`

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
