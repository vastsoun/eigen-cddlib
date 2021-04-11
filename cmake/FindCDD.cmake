#=============================================================================
# Copyright (C) 2020, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# Authors: Vassilios Tsounis, Mitja Alge
#=============================================================================
# FindCDD.cmake
#
# Finds the CDD library for integration into CMake projects.
#
# This will define the following imported targets:
#    cdd::cdd
#
# In addition, following variables will also be defined:
#    CDD_FOUND
#    CDD_INCLUDE_DIRS
#    CDD_LIBRARIES
#=============================================================================
include(FindPackageHandleStandardArgs)

#==
# Options
#==

option(CDD_USE_GMP "Import CDD built with GMP rational numbers." OFF)

#==
# Dependencies
#==

#
# NOTE: We first use PkgConfig (*.pc) to perform an initial search for cddlib.
#

# cddlib: A C implementation of the Double Description Method of Motzkin et al.
find_package(PkgConfig)
pkg_check_modules(CDD REQUIRED cddlib)
if(CDD_FOUND)
  message(STATUS "PkgConfig: Found cddlib with:")
  message(STATUS "  Version: ${CDD_VERSION}")
  message(STATUS "  Prefix: ${CDD_PREFIX}")
  message(STATUS "  Includes: ${CDD_INCLUDE_DIRS}")
  message(STATUS "  Libraries: ${CDD_LINK_LIBRARIES}")
else()
  message(FATAL_ERROR "cddlib not found! Please install using APT:\nsudo apt install libcdd-dev")
endif()

# Unset found flag to ensure correct package configuration
unset(CDD_FOUND CACHE)
unset(CDD_LIBRARIES CACHE)

#==
# Library headers and binaries
#==

# NOTE: We also provide an option to specify whether to use the GMP variant.
if(CDD_USE_GMP)
  message(STATUS "cddlib: Using version compiled with GMP.")
  set(CDD_LIBRARY libcddgmp.so)
else()
  set(CDD_LIBRARY libcdd.so)
endif()

## NOTE: We don't need to import the headers since they've already been found by PkgConfig.
# We will import the specified variant of CDD.
find_library(CDD_LIBRARIES SHARED IMPORTED
  NAMES ${CDD_LIBRARY}
  PATHS ${CDD_PREFIX}
)

#==
# Check package contents
#==

find_package_handle_standard_args(CDD
  REQUIRED_VARS
    CDD_VERSION
    CDD_INCLUDE_DIRS
    CDD_LIBRARIES
)

# Print useful output if the package variables were set.
if(CDD_FOUND)
  message(STATUS "cddlib:")
  message(STATUS "  Version: ${CDD_VERSION}")
  message(STATUS "  Prefix: ${CDD_PREFIX}")
  message(STATUS "  Includes: ${CDD_INCLUDE_DIRS}")
  message(STATUS "  Libraries: ${CDD_LIBRARIES}")
else()
  message(FATAL_ERROR "Failed to locate cddlib: Make sure it has been installed via:\nsudo apt install libcdd-dev\n")
endif()

mark_as_advanced(CDD_FOUND CDD_INCLUDE_DIRS CDD_LIBRARIES)

#==
# Package targets
#==

# NOTE: We also provide a name-scoped (modern) CMake target.
if(CDD_FOUND AND NOT TARGET cdd::cdd)
  add_library(cdd::cdd INTERFACE IMPORTED)
  set_target_properties(cdd::cdd PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CDD_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES "${CDD_LIBRARIES}"
  )
endif()

# EOF
