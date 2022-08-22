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
$MsvcBuildDir = Join-Path -Path $BuildDir -ChildPath 'msvc'

if(-Not (Test-Path -Path $MsvcBuildDir -PathType Container)) {
	& $CMake -S $SourceDir --preset msvc
}

# Build
$Presets = 'msvc-debug', 'msvc-release'
foreach($preset in $Presets) {
	$CMakeArgs = @(
		'--build'
		'--preset'
		$preset
		'--target'
		'PACKAGE'
	)
	$processOptions = @{
		FilePath = $CMake
		WorkingDirectory = $SourceDir
		ArgumentList = $CMakeArgs
	}
	Start-Process @processOptions -NoNewWindow -Wait
}
