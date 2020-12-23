#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "eigen-cdd::eigen-cddlib" for configuration "Debug"
set_property(TARGET eigen-cdd::eigen-cddlib APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(eigen-cdd::eigen-cddlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libeigen-cddlib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS eigen-cdd::eigen-cddlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_eigen-cdd::eigen-cddlib "${_IMPORT_PREFIX}/lib/libeigen-cddlib.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
