#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "glslang::SPIRV" for configuration "Debug"
set_property(TARGET glslang::SPIRV APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(glslang::SPIRV PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libSPIRV.so.16.6.0"
  IMPORTED_SONAME_DEBUG "libSPIRV.so.16"
  )

list(APPEND _cmake_import_check_targets glslang::SPIRV )
list(APPEND _cmake_import_check_files_for_glslang::SPIRV "${_IMPORT_PREFIX}/lib/libSPIRV.so.16.6.0" )

# Import target "glslang::glslang" for configuration "Debug"
set_property(TARGET glslang::glslang APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(glslang::glslang PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libglslang.so.16.6.0"
  IMPORTED_SONAME_DEBUG "libglslang.so.16"
  )

list(APPEND _cmake_import_check_targets glslang::glslang )
list(APPEND _cmake_import_check_files_for_glslang::glslang "${_IMPORT_PREFIX}/lib/libglslang.so.16.6.0" )

# Import target "glslang::glslang-default-resource-limits" for configuration "Debug"
set_property(TARGET glslang::glslang-default-resource-limits APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(glslang::glslang-default-resource-limits PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libglslang-default-resource-limits.so.16.6.0"
  IMPORTED_SONAME_DEBUG "libglslang-default-resource-limits.so.16"
  )

list(APPEND _cmake_import_check_targets glslang::glslang-default-resource-limits )
list(APPEND _cmake_import_check_files_for_glslang::glslang-default-resource-limits "${_IMPORT_PREFIX}/lib/libglslang-default-resource-limits.so.16.6.0" )

# Import target "glslang::glslang-standalone" for configuration "Debug"
set_property(TARGET glslang::glslang-standalone APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(glslang::glslang-standalone PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/glslang"
  )

list(APPEND _cmake_import_check_targets glslang::glslang-standalone )
list(APPEND _cmake_import_check_files_for_glslang::glslang-standalone "${_IMPORT_PREFIX}/bin/glslang" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
