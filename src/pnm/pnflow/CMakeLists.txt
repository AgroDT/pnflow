add_executable(pnflow
    polygon/cornerApex.cpp
    polygon/layerApex.cpp
    polygon/polygon_calcR.cpp
    polygon/polygon.cpp
    polygon/polygonDrain.cpp
    polygon/polygonImb.cpp
    psPrc/netStatistics.cpp
    psPrc/vtuWriter.cpp
    elem_Model.cpp
    Element.cpp
    ElementConstSolver.cpp
    ElementPore.cpp
    ElementThroat.cpp
    FlowDomain_drain.cpp
    FlowDomain_imbibe.cpp
    FlowDomain.cpp
    hypreSolver.cpp
    inputData.cpp
    NetworkTransform.cpp
    pnflow.cpp
)

set_target_properties(pnflow PROPERTIES CXX_STANDARD 17)

target_compile_options(pnflow PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/W4>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wpedantic>
)

target_include_directories(pnflow PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/polygon>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/psPrc>
)

target_link_libraries(pnflow PRIVATE
    ${CMAKE_PROJECT_NAME}::utils
    HYPRE::HYPRE
    ZLIB::ZLIB
    TIFF::TIFF
)

string(TIMESTAMP TODAY "%Y.%m.%d" UTC)
set(RELEASE_DATE ${TODAY} CACHE STRING "Release Date")
target_compile_definitions(pnflow PRIVATE -DRELEASE_DATE="${RELEASE_DATE}")

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

install(TARGETS pnflow
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    ${RUNTIME_DEPENDENCIES}
)
