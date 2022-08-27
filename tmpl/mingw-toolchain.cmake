#
# MinGW CMake toolchain
#
SET(MINGW_DIR @MINGW_DIR@)
SET(CMAKE_C_COMPILER ${MINGW_DIR}/bin/gcc.exe)
SET(CMAKE_CXX_COMPILER ${MINGW_DIR}/bin/g++.exe)
SET(CMAKE_RC_COMPILER ${MINGW_DIR}/bin/windres.exe)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

SET(CMAKE_C_VISIBILITY_PRESET hidden)
SET(CMAKE_CXX_VISIBILITY_PRESET hidden)
SET(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

SET(_COMMON_GCC_FLAGS "-fdiagnostics-plain-output")
SET(CMAKE_C_FLAGS_INIT "${_COMMON_GCC_FLAGS} \"-ffile-prefix-map=${MINGW_DIR}=./gcc\"")
SET(CMAKE_CXX_FLAGS_INIT "${_COMMON_GCC_FLAGS} \"-ffile-prefix-map=${MINGW_DIR}=./gcc\"")
SET(CMAKE_MODULE_LINKER_FLAGS_INIT "${_COMMON_GCC_FLAGS}")
SET(CMAKE_SHARED_LINKER_FLAGS_INIT "${_COMMON_GCC_FLAGS} -Wl,-allow-multiple-definition")
SET(CMAKE_EXE_LINKER_FLAGS_INIT "${_COMMON_GCC_FLAGS} -Wl,-allow-multiple-definition")
UNSET(_COMMON_GCC_FLAGS)
