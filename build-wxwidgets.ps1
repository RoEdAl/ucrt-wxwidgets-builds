#
# build-wxwidgets.ps1
#

# CMake
$CMakeDir = Join-Path -Path $Env:ProgramFiles -ChildPath 'CMake'
$CMakeBinDir = Join-Path -Path $CMakeDir -ChildPath 'bin'
$CMake = Join-Path -Path $CMakeBinDir -ChildPath 'cmake'

# Source directory
$SourceDir = Join-Path -Path $PSScriptRoot -ChildPath 'src'

# Build directory
$BuildDir = Join-Path -Path $PSScriptRoot -ChildPath 'build'

if(-Not (Test-Path -Path $BuildDir -PathType Container)) {
	& $CMake -S $SourceDir --preset mingw64
}

# Build
$Presets = 'mingw64-debug', 'mingw64-release'
foreach($preset in $Presets) {
	$CMakeArgs = @(
		'--build'
		'--preset'
		$preset
		'--target'
		'package'
	)
	$processOptions = @{
		FilePath = $CMake
		WorkingDirectory = $SourceDir
		ArgumentList = $CMakeArgs
	}
	Start-Process @processOptions -NoNewWindow -Wait
}
