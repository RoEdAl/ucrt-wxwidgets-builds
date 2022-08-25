#
# mingw-build-wxwidgets.ps1
#

function git_status {
	param (
		$RepoDir
	)
	
	try {
		Push-Location -Path $RepoDir
		$res = & $git status --porcelain
		if ( $? ) {
			return $res.replace("\s+",'').Length -eq 0
		} else {
			Write-Error 'Fail to execute git status' -ErrorAction Stop
		}
	}
	finally {
		Pop-Location
	}
}

function git_last_commit_ts {
	param (
		$RepoDir
	)
	
	try {
		Push-Location -Path $RepoDir
		$res = & $git log -n 1 '--pretty=format:%ct'
		if ( $? ) {
			return [int]::Parse($res.replace("\s+",''))
		} else {
			Write-Error 'Fail to execute git log' -ErrorAction Stop
		}
	}
	finally {
		Pop-Location
	}	
}

function dt_from_unix_epoch {
	param (
		$UnixEpoch
	)
	
	$args = @(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
	$params = @{
		TypeName = 'System.DateTime'
		ArgumentList = $args
	}
	$res = New-Object @params
    return $res.AddSeconds( $UnixEpoch )
}

# CMake
$CMakeDir = Join-Path -Path $Env:ProgramFiles -ChildPath 'CMake'
$CMakeBinDir = Join-Path -Path $CMakeDir -ChildPath 'bin'
$CMake = Join-Path -Path $CMakeBinDir -ChildPath 'cmake'

# git
$GitDir = Join-Path -Path $Env:ProgramFiles -ChildPath 'git'
$GitBinDir = Join-Path -Path $GitDir -ChildPath 'bin'
$Git = Join-Path -Path $GitBinDir -ChildPath 'git'

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
