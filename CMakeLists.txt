# eigen-cddlib: wraps cddlib with Eigen matrix
#=============================================================================
# Copyright (C) 2020, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# Authors: Vassilios Tsounis, Johannes Conradi
#=============================================================================

cmake_minimum_required(VERSION 3.10)
project(eigen-cddlib VERSION 0.0.1 LANGUAGES CXX)

# Include CMake helper modules
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

#==
# Options
#==

option(BUILD_TESTING "Build unit tests." ON)
option(BUILD_TEST_STATIC_BOOST "Build unit tests with static boost libraries" ON)
set(DENABLE_PRECOMPILED_HEADERS=OFF)

#==
# Dependencies
#==

# Eigen3
find_package(Eigen3 CONFIG REQUIRED)

# Apt-get package of C libcdd-dev project
find_package(cdd CONFIG REQUIRED)

#==
# Build target libraries
#==

set(${PROJECT_NAME}_SRC
        ${CMAKE_CURRENT_LIST_DIR}/src/Polyhedron.cpp
        )

# TODO might need to consider different library type (static vs shared)

add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_SRC})

target_include_directories(${PROJECT_NAME}
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        $<INSTALL_INTERFACE:include>
        )
target_link_libraries(${PROJECT_NAME}
        PUBLIC
        cdd::cdd
        )
target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC "${EIGEN3_INCLUDE_DIR}")
target_compile_options(${PROJECT_NAME} PUBLIC -fPIC)
add_library(eigen-cdd::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_14)

# TODO add this
#add_subdirectory(tests)


#==
# Package targets
#==
#message(ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
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

write_basic_package_version_file(cmake/${PROJECT_NAME}-config-version.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
        )

#==
# Package installation
#==

install(
        FILES
        ${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}-config-version.cmake
        DESTINATION
        ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake
)

install(
        DIRECTORY
        ${CMAKE_CURRENT_LIST_DIR}/include/${PROJECT_NAME}
        DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}
)

#==
# Unit tests
#==
# TODO

# EOF

#include(cmake/base.cmake)
#
#set(PROJECT_NAME eigen-cdd)
#set(PROJECT_DESCRIPTION "Eigen C++ wrapper for using cddlib")
#set(PROJECT_URL "https://github.com/vsamy/eigen-cddlib")
#set(PROJECT_DEBUG_POSTFIX "_d")
#set(INSTALL_GENERATED_HEADERS OFF CACHE BOOL "Generate and install standard headers")
#
#set(DOXYGEN_USE_MATHJAX "YES")
#set(CMAKE_CXX_STANDARD 11)
#
#option(BUILD_TESTING "Build unit tests." ON)
#option(BUILD_TEST_STATIC_BOOST "Build unit tests with static boost libraries" OFF)
#
#setup_project()
#
#set(Eigen_REQUIRED "eigen3 >= 3.2")
#add_project_dependency(Eigen3 REQUIRED)
#add_project_dependency(cdd REQUIRED)
#
#add_subdirectory(src)
#
#if(${BUILD_TESTING})
#    add_subdirectory(tests)
#endif()
#
#setup_project_finalize()
#setup_project_package_finalize()
