wxwidgets-builds

[wxWidgets](http://www.wxwidgets.org/) builds - MinGW64, MSVC.

* MinGW toolchain - [ucrt-mingw-builds](https://github.com/RoEdAl/ucrt-mingw-builds).
* [CMake](http://cmake.org/) build system + [Ninja](http://ninja-build.org/) build system.

## Requirements

* *CMake*, minimum version: 3.24.
* [Git for Windows](http://gitforwindows.org/).
* MS Visual Studio.

## Scripts

* `make-workdir.ps1` - download required packages, prepare work directory
* `mingw-build-wxwidgets.ps1` - *MinGW64* - compile & build packages
* `msvc-build-wxwidgets.ps1` - *MS Visual Studio* - compile & build packages

## wxWidgets configuration

*wxWidgets* library configuration is stored in [presets](tmpl/CMakePresets.json) file.
Preset name is *wxwidgets*.
