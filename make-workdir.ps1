#
# make-workdir.ps1
#

$ScriptsPath = Join-Path -Path $PSScriptRoot -ChildPath 'scripts'
$CMakeScript = Join-Path -Path $ScriptsPath -ChildPath 'cmake.ps1'
. $CMakeScript

try {
	Push-Location -Path $PSScriptRoot
	& $CMake -P 'make-workdir.cmake'
}
finally {
	Pop-Location
}
