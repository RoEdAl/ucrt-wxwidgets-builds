#
# mingw-build-wxwidgets.ps1
#

$ScriptsPath = Join-Path -Path $PSScriptRoot -ChildPath 'scripts'
$CMakeScript = Join-Path -Path $ScriptsPath -ChildPath 'cmake.ps1'
$GitScript = Join-Path -Path $ScriptsPath -ChildPath 'git.ps1'

. $CMakeScript
. $GitScript

# Source directory
$SourceDir = Join-Path -Path $PSScriptRoot -ChildPath 'src'

if ( -Not (git_status $SourceDir) ) {
	Write-Error 'There are uncommited changes' -ErrorAction Stop
}

$gts = git_last_commit_ts $SourceDir
$ts = dt_from_unix_epoch $gts
Write-Host "Timestamp: $ts [@$gts]"

$envs = @(
	"SOURCE_DATE_EPOCH=$gts"
)

# Build directory
$BuildDir = Join-Path -Path $PSScriptRoot -ChildPath 'build'
$MingwBuildDir = Join-Path -Path $BuildDir -ChildPath 'mingw64'

if(-Not (Test-Path -Path $MingwBuildDir -PathType Container)) {
	& $CMake -E env @envs $CMake -S $SourceDir --preset mingw64
	if ( -Not $? ) {
		exit
	}
}

# Build
$Presets = 'mingw64-debug', 'mingw64-release'
foreach($preset in $Presets) {
	try {
		Push-Location -Path $SourceDir
		& $CMake -E env @envs $CMake --build --preset $preset --target 'package'
		if ( -Not $? ) {
			exit
		}
	}
	finally {
		Pop-Location
	}
}
