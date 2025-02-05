include(CMakeDependentOption)
include(FetchContent)

option(
    USE_SYSTEM_DEPENDENCIES
    "Try to use system dependencies; control each dependency with USE_SYSTEM_<dependency_name>"
    ON
)

if(NOT DEFINED MPI_FOUND)
    find_package(MPI)
endif()
set(HYPRE_WITH_MPI ${MPI_FOUND})
set(BUNDLED_DEPENDENCIES "")

macro(test_system_dependency NAME SOURCE_DIR)
    cmake_dependent_option(USE_SYSTEM_${NAME} "Try to use system ${NAME}" ON "USE_SYSTEM_DEPENDENCIES" OFF)
    if(USE_SYSTEM_${NAME})
        find_package(${NAME})
    endif()
    if(${NAME}_FOUND)
        message(STATUS "Using system ${NAME}")
    else()
        FetchContent_Declare(${NAME} SOURCE_DIR ${SOURCE_DIR})
        list(APPEND BUNDLED_DEPENDENCIES ${NAME})
        set(USE_BUNDLED_${NAME} TRUE)
        message(STATUS "Using bundled ${NAME}")
    endif()
endmacro()

test_system_dependency(HYPRE "${CMAKE_SOURCE_DIR}/pkgs/hypre/src")
test_system_dependency(TIFF "${CMAKE_SOURCE_DIR}/pkgs/libtiff")
test_system_dependency(ZLIB "${CMAKE_SOURCE_DIR}/pkgs/zlib")

if(BUNDLED_DEPENDENCIES)
    FetchContent_MakeAvailable(${BUNDLED_DEPENDENCIES})
endif()

if(USE_BUNDLED_HYPRE)
    add_library(HYPRE::HYPRE ALIAS HYPRE)
endif()

if(USE_BUNDLED_TIFF)
    add_library(TIFF::TIFF ALIAS tiff)
endif()

if(USE_BUNDLED_ZLIB)
    add_library(ZLIB::ZLIB ALIAS zlib)
endif()
