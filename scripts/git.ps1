#
# git.ps1
#

# git
$GitDir = Join-Path -Path $Env:ProgramFiles -ChildPath 'git'
$GitBinDir = Join-Path -Path $GitDir -ChildPath 'bin'
$Git = Join-Path -Path $GitBinDir -ChildPath 'git'

function git_status {
	param (
		$RepoDir
	)
	
	try {
		Push-Location -Path $RepoDir
		$res = & $Git status --porcelain
		if ( $? ) {
			return [string]::IsNullOrWhiteSpace($res)
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
		$res = & $Git log -n 1 '--pretty=format:%ct'
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
