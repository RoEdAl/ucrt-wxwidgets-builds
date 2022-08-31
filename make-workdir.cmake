﻿#
# make-workdir.cmake
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
INCLUDE(ProcessorCount)
INCLUDE(scripts/utils.cmake)
INCLUDE(scripts/patch.cmake)

# currently hardcoded configuration

ProcessorCount(PARALLEL_LEVEL)
SET(WXWIDGETS_VERSION "3.2.0")
SET(WEBVIEW2_VERSION "1.0.1293.44")
SET(WX_WORKDIR ${CMAKE_SOURCE_DIR})
CMAKE_PATH(ABSOLUTE_PATH WX_WORKDIR NORMALIZE)
#RemoveLastChar(${WX_WORKDIR})



# show configuration

MESSAGE(STATUS "[CFG] wxWidgets version: ${WXWIDGETS_VERSION}")
MESSAGE(STATUS "[CFG] Workdir: ${WX_WORKDIR}")
MESSAGE(STATUS "[CFG] Jobs: ${PARALLEL_LEVEL}")

SET(MSVC_GENERATOR "Visual Studio 17 2022")
SET(MSVC_TOOLSET "v143,host=x64")

# downloading

CMAKE_PATH(APPEND WX_WORKDIR download OUTPUT_VARIABLE WX_DLDIR)

SET(URL_WXWIDGETS "http://github.com/wxWidgets/wxWidgets/releases/download/v${WXWIDGETS_VERSION}")
DownloadPkgSha1(${URL_WXWIDGETS} wxWidgets-${WXWIDGETS_VERSION}.7z 14b14fc4c5f19f8a0892e09bf3dd115e188540de "wxWidgets source")

SET(URL_NINJA "http://github.com/ninja-build/ninja/releases/download/v1.11.0")
DownloadPkgSha1(${URL_NINJA} ninja-win.zip 31c7b577d3e5be57eb8acca527f73a484ace7d8c "Ninja builder")

SET(URL_MINGW64 "https://github.com/RoEdAl/ucrt-mingw-builds/releases/download/v12.2.0-rt10-ucrt2")
DownloadPkgSha1(${URL_MINGW64} x86_64-12.2.0-release-win32-seh-rt_v10-rev0.7z 5de70c97911ba10a591cbf6290e75f336ab0f635 "MinGW64 runtime")
	
SET(URL_GCC "http://gcc.gnu.org/onlinedocs/gcc-12.2.0")
DownloadPkgSha1(${URL_GCC} gcc.pdf becbd022de78a4f818d53d3229a19f9edb03f88e "GCC documentation - PDF")
DownloadPkgSha1(${URL_GCC} gcc-html.tar.gz e3ef867a3803961b01fbd57e7c5d19bc36757573 "GCC documentation - HTML")

SET(URL_WEBVIEW2 "https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2")
DownloadPkgSha1Ex(${URL_WEBVIEW2}/${WEBVIEW2_VERSION} microsoft.web.webview2.${WEBVIEW2_VERSION}.nupkg 6cf1655775e6fda4b731bde781212e0d370987ad "WebView2" TRUE)

# extracting

CMAKE_PATH(APPEND WX_WORKDIR src OUTPUT_VARIABLE WX_SRC_DIR)

CMAKE_PATH(APPEND WX_SRC_DIR include msvc wx setup.h OUTPUT_VARIABLE WX_TEST_FILE)
IF(NOT EXISTS ${WX_TEST_FILE})
	MESSAGE(STATUS "[EXTR] wxWidgets source")
	FILE(ARCHIVE_EXTRACT INPUT ${WX_DLDIR}/wxWidgets-${WXWIDGETS_VERSION}.7z DESTINATION ${WX_SRC_DIR})
	SET(PATCH_SET 
		0001-CMake-install-builtin-libraries.patch
		0002-CMake-CMP0063.patch
		0003-CMake-GCC-use-language-specific-compile-options.patch
		0004-CMake-define-_CRT_NONSTDC_NO_WARNINGS-for-MSVC-only.patch
		0005-CMake-CPack.patch
		0006-CMake-install-PDB-files.patch
		0007-CMake-do-dot-override-wxUSE_XML-by-wxUSE_XLR.patch
		0008-CMake-CMP0069.patch
		0009-wxWebViewEdge-handle-more-error-codes.patch
		0010-CMake-wxwebview-define-_CONTROL_FLOW_GUARD_XFG.patch
	)
	FOREACH(P IN LISTS PATCH_SET)
		ApplyPatch(${WX_WORKDIR}/patch/${P} ${WX_SRC_DIR})
	ENDFOREACH()
ENDIF()

CMAKE_PATH(APPEND WX_SRC_DIR 3rdparty webview2 OUTPUT_VARIABLE WEBVIEW2_DIR)
IF(NOT EXISTS ${WEBVIEW2_DIR})
	MESSAGE(STATUS "[EXTR] WebView2")
	FILE(ARCHIVE_EXTRACT INPUT ${WX_DLDIR}/microsoft.web.webview2.${WEBVIEW2_VERSION}.nupkg DESTINATION ${WEBVIEW2_DIR})
ENDIF()

CMAKE_PATH(APPEND WX_WORKDIR ninja ninja.exe OUTPUT_VARIABLE NINJA_BINARY)
IF(NOT EXISTS ${NINJA_BINARY})
	MESSAGE(STATUS "[EXTR] Ninja builder")
	FILE(ARCHIVE_EXTRACT INPUT ${WX_DLDIR}/ninja-win.zip DESTINATION ${WX_WORKDIR}/ninja)
ENDIF()

CMAKE_PATH(APPEND WX_WORKDIR mingw64 OUTPUT_VARIABLE MINGW_DIR)
IF(NOT EXISTS ${MINGW_DIR})
	MESSAGE(STATUS "[EXTR] MinGW64 runtime")
	FILE(ARCHIVE_EXTRACT INPUT ${WX_DLDIR}/x86_64-12.2.0-release-win32-seh-rt_v10-rev0.7z DESTINATION ${WX_WORKDIR})
ENDIF()
	
CMAKE_PATH(APPEND MINGW_DIR doc OUTPUT_VARIABLE MINGW_DOC_DIR)
IF(NOT EXISTS ${MINGW_DOC_DIR})
	MESSAGE(STATUS "[EXTR] GCC documentation - HTML")
	FILE(ARCHIVE_EXTRACT INPUT ${WX_DLDIR}/gcc-html.tar.gz DESTINATION ${MINGW_DIR})
	CMAKE_PATH(APPEND MINGW_DIR gcc OUTPUT_VARIABLE MINGW_GCC_DIR)
	FILE(RENAME ${MINGW_GCC_DIR} ${MINGW_DOC_DIR})
ENDIF()
	
CMAKE_PATH(APPEND MINGW_DIR gcc.pdf OUTPUT_VARIABLE MINGW_GCC_PDF)
IF(NOT EXISTS ${MINGW_GCC_PDF})
	MESSAGE(STATUS "[EXTR] GCC documentation - PDF")
	FILE(CREATE_LINK ${WX_DLDIR}/gcc.pdf ${MINGW_GCC_PDF} COPY_ON_ERROR)
ENDIF()

# MINGW toolchain

CMAKE_PATH(APPEND MINGW_DIR mingw-toolchain.cmake OUTPUT_VARIABLE MW64_TOOLCHAIN_FILE)
IF(NOT EXISTS ${MW64_TOOLCHAIN_FILE})
	MESSAGE(STATUS "[CFGF] MinGW toolchain: ${MW64_TOOLCHAIN_FILE}")
	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/tmpl/mingw-toolchain.cmake ${MW64_TOOLCHAIN_FILE} NO_SOURCE_PERMISSIONS @ONLY)
ENDIF()

# presets file: CMakeUserPresets.json

CMAKE_PATH(APPEND CMAKE_SOURCE_DIR src CMakeUserPresets.json OUTPUT_VARIABLE PRESETS_FILE)
IF(NOT EXISTS ${PRESETS_FILE})
	MESSAGE(STATUS "[CFGF] Preset ${PRESETS_FILE}")
	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/tmpl/CMakePresets.json ${PRESETS_FILE} NO_SOURCE_PERMISSIONS @ONLY)
ENDIF()
