cmake_minimum_required(VERSION 3.5.0)
project(pnflow VERSION 0.1.0 LANGUAGES CXX)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)
include(AddDependencies)

add_subdirectory(src/include)
add_subdirectory(src/pnm/pnflow)
