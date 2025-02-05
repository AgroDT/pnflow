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

if(MINGW)
    cmake_path(GET CMAKE_CXX_COMPILER PARENT_PATH DIRECTORIES)
    foreach(LIB HYPRE::HYPRE ZLIB::ZLIB TIFF::TIFF)
        get_target_property(_LIB_FILE HYPRE::HYPRE IMPORTED_LOCATION)
        cmake_path(GET _LIB_FILE PARENT_PATH _LIB_DIR)
        cmake_path(REPLACE_FILENAME _LIB_DIR bin)
        list(APPEND DIRECTORIES "${_LIB_DIR}")
    endforeach()
    list(REMOVE_DUPLICATES DIRECTORIES)
    set(RUNTIME_DEPENDENCIES RUNTIME_DEPENDENCIES
        PRE_EXCLUDE_REGEXES "api-ms-" "ext-ms-"
        POST_EXCLUDE_REGEXES ".*system32/.*\\.dll"
        DIRECTORIES ${DIRECTORIES}
    )
endif()
