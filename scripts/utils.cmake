#
#

FUNCTION(RemoveLastChar Str)
	STRING(LENGTH ${Str} StrLen)
	MATH(EXPR StrLen1 "${StrLen}-1")
	STRING(SUBSTRING ${Str} 0 ${StrLen1} StrTrimmed)
	SET(WX_WORKDIR ${StrTrimmed} PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(DownloadPkgSha1Ex UrlBase FileName Sha1Hash StatusMsg FullUrl)
	CMAKE_PATH(APPEND WX_DLDIR ${FileName} OUTPUT_VARIABLE PkgPath)
	
	IF(EXISTS ${PkgPath})
		FILE(SHA1 ${PkgPath} PkgHash)
		IF(NOT(${PkgHash} STREQUAL ${Sha1Hash}))
			MESSAGE(STATUS "[DL] ${FileName}: expected SHA-1: ${Sha1Hash}, computed SHA-1: ${PkgHash}")
			MESSAGE(STATUS "[DL] Invalid SHA-1 for file ${FileName}")
			FILE(REMOVE ${PkgPath})
		ELSE()
			MESSAGE(VERBOSE "[DL] File ${FileName} already downloaded")
			RETURN()
		ENDIF()
	ENDIF()
	
	MESSAGE(STATUS "[DL] ${StatusMsg}")
	IF(FullUrl)
		SET(FILE_URL ${UrlBase})
	ELSE()
		SET(FILE_URL ${UrlBase}/${FileName})
	ENDIF()
	MESSAGE(VERBOSE "[DL] ${FILE_URL}")
	FILE(DOWNLOAD ${FILE_URL} ${PkgPath}
		EXPECTED_HASH SHA1=${Sha1Hash}
		INACTIVITY_TIMEOUT 60
		TIMEOUT 300
	)
ENDFUNCTION()

FUNCTION(DownloadPkgSha1 UrlBase FileName Sha1Hash StatusMsg)
	DownloadPkgSha1Ex(${UrlBase} ${FileName} ${Sha1Hash} ${StatusMsg} FALSE)
ENDFUNCTION()

