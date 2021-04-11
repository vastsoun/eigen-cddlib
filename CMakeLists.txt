#=============================================================================
# eigen-cddlib: wraps cddlib with Eigen matrix
# Copyright (C) 2019 Vincent Samy
#=============================================================================
# Copyright (C) 2020, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# Authors: Vincent Samy, Vassilios Tsounis, Johannes Conradi
#=============================================================================
cmake_minimum_required(VERSION 3.10)
project(eigen-cdd VERSION 1.1.0 LANGUAGES CXX)

# Include CMake helper modules
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

#==
# Options
#==

option(BUILD_TESTING "Build unit tests." ON)
option(BUILD_TEST_STATIC_BOOST "Build unit tests with static boost libraries" OFF)

#==
# Dependencies
#==

# Add project cmake directory for loading dependency modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# cddlib: A C implementation of the Double Description Method of Motzkin et al.
find_package(CDD MODULE REQUIRED)

# Eigen: A C++ template library for linear algebra
find_package(Eigen3 CONFIG REQUIRED)

#==
# Build target libraries
#==

set(${PROJECT_NAME}_SRC ${CMAKE_CURRENT_LIST_DIR}/src/Polyhedron.cpp)

add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_SRC})
target_include_directories(${PROJECT_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
    $<BUILD_INTERFACE:${CDD_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include>
)
target_link_libraries(${PROJECT_NAME}
  PUBLIC
    cdd::cdd
)
target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC "${EIGEN3_INCLUDE_DIR}")
target_compile_options(${PROJECT_NAME} PUBLIC -fPIC)
add_library(eigen-cdd::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_14)

#==
# Package targets
#==

install(TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}-targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

export(TARGETS ${PROJECT_NAME}
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}-targets.cmake
)

install(EXPORT ${PROJECT_NAME}-targets
  FILE ${PROJECT_NAME}-targets.cmake
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake
)

#==
# Package configuration
#==

configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/cmake/${PROJECT_NAME}-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake
)

write_basic_package_version_file(
  cmake/${PROJECT_NAME}-config-version.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

file(
  COPY
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindCDD.cmake
  DESTINATION
    ${CMAKE_CURRENT_BINARY_DIR}/cmake
)

#==
# Package installation
#==

install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/FindCDD.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}-config-version.cmake
  DESTINATION
    ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake
)

# Headers
install(
  DIRECTORY
    ${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}
  DESTINATION
    ${CMAKE_INSTALL_INCLUDEDIR}
)

#==
# Unit tests
#==

if(${BUILD_TESTING})
  add_subdirectory(tests)
endif()

# EOF
