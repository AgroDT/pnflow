cmake_minimum_required(VERSION 3.10.0)
project(pnflow VERSION 0.1.0 LANGUAGES CXX)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(GNUInstallDirs)
include(AddDependencies)

string(TIMESTAMP TODAY "%Y.%m.%d" UTC)
set(RELEASE_DATE ${TODAY} CACHE STRING "Release Date")

add_subdirectory(src/include)
add_subdirectory(src/pnm/pnextract)
add_subdirectory(src/pnm/pnflow)
