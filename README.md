# ucrt-wxwidgets-builds

MinGW [UCRT] based [wxWidgets](http://www.wxwidgets.org/) builds.

* MinGW toolchain - [ucrt-mingw-builds](https://github.com/RoEdAl/ucrt-mingw-builds).
* [CMake](http://cmake.org/) build system + [Ninja](http://ninja-build.org/) build system.

## Requirements

* CMake, minimum version: 3.24.
* [Git for Windows](http://gitforwindows.org/).

## Scripts

* `make-workdir.ps1` - download required packages, prepare work directory
* `build-wxwidgets.ps1` - compile & build packages
