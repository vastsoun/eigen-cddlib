#=============================================================================
# Copyright (C) 2020, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# Authors: Vassilios Tsounis
#=============================================================================
#
# Finds the eigen-cddlib library for integration into CMake projects.
#
# This will define the following imported targets:
#    eigen-cdd::eigen-cddlib
#
# In addition, following variables will also be defined:
#    eigen-cddlib_FOUND
#    eigen-cddlib_INCLUDE_DIRS
#    eigen-cddlib_LIBRARIES
#=============================================================================
include(FindPackageHandleStandardArgs)

# Unset found flag to ensure correct package configuration
unset(eigen-cddlib_FOUND)

#==
# Dependencies
#==

# Eigen3
find_package(Eigen3 CONFIG REQUIRED)

# Apt-get package of C libcdd-dev project (might not find it)
find_package(cdd REQUIRED)

#==
# Pacakge contents
#==

if(NOT TARGET eigen-cdd::eigen-cddlib)
  include(${CMAKE_CURRENT_LIST_DIR}/eigen-cddlib-targets.cmake)
  message(eigen-cdd::eigen-cddlib not a target yet)
endif()

get_target_property(eigen-cddlib_INCLUDE_DIRS eigen-cdd::eigen-cddlib INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(eigen-cddlib_LIBRARIES eigen-cdd::eigen-cddlib INTERFACE_LINK_LIBRARIES)
list(APPEND eigen-cddlib_LIBRARIES eigen-cdd::eigen-cddlib)

#==
# Pacakge configuration check
#==

find_package_handle_standard_args(eigen-cddlib
  REQUIRED_VARS
    eigen-cddlib_VERSION
    eigen-cddlib_INCLUDE_DIRS
    eigen-cddlib_LIBRARIES
)

if(eigen-cddlib_FOUND)
  message(STATUS "eigen-cddlib:")
  message(STATUS "  Version: ${eigen-cddlib_VERSION}")
  message(STATUS "  Includes: ${eigen-cddlib_INCLUDE_DIRS}")
  message(STATUS "  Libraries: ${eigen-cddlib_LIBRARIES}")
endif()

mark_as_advanced(eigen-cddlib_FOUND eigen-cddlib_INCLUDE_DIRS eigen-cddlib_LIBRARIES)

# EOF
