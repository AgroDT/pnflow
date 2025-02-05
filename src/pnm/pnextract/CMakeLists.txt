add_executable(pnextract
    blockNet.cpp
    nextract.cpp
    medialSurf.cpp
    writers_vtk.cpp
    writers_vxl.cpp
    ../../libvoxel/voxelImage.cpp
)

set_target_properties(pnextract PROPERTIES CXX_STANDARD 17)

target_compile_options(pnextract PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/W4>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wpedantic>
)

target_include_directories(pnextract PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../libvoxel>
)

target_link_libraries(pnextract PRIVATE
    ${CMAKE_PROJECT_NAME}::utils
    ZLIB::ZLIB
    TIFF::TIFF
)

target_compile_definitions(pnextract PRIVATE
    -DEXPERIMENTAL
    -DRELEASE_DATE="${RELEASE_DATE}"
)

install(TARGETS pnextract
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    ${RUNTIME_DEPENDENCIES}
)
