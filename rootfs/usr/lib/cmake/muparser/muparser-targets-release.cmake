#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "muparser::muparser" for configuration "Release"
set_property(TARGET muparser::muparser APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(muparser::muparser PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmuparser.so.2.3.5"
  IMPORTED_SONAME_RELEASE "libmuparser.so.2"
  )

list(APPEND _cmake_import_check_targets muparser::muparser )
list(APPEND _cmake_import_check_files_for_muparser::muparser "${_IMPORT_PREFIX}/lib/libmuparser.so.2.3.5" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
