#
# make-workdir.ps1
#

$CMakeDir = Join-Path -Path $Env:ProgramFiles -ChildPath 'CMake'
$CMakeBinDir = Join-Path -Path $CMakeDir -ChildPath 'bin'
$CMake = Join-Path -Path $CMakeBinDir -ChildPath 'cmake'

try {
	Push-Location -Path $PSScriptRoot
	& $CMake -P 'make-workdir.cmake'
}
finally {
	Pop-Location
}
