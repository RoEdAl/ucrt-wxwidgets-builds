#
# patch
#

SET(GIT $ENV{ProgramFiles}/git/bin/git.exe)
SET(PATCH $ENV{ProgramFiles}/git/usr/bin/patch.exe)

if(NOT EXISTS ${PATCH})
  MESSAGE(FATAL_ERROR "Did not find patch utility")
endif()

FUNCTION(ApplyPatch in_file work_dir)
	EXECUTE_PROCESS(COMMAND ${PATCH} -N -p1 -s -t -i ${in_file}
		WORKING_DIRECTORY ${work_dir}
		TIMEOUT 15
		COMMAND_ERROR_IS_FATAL ANY
	)
ENDFUNCTION()
