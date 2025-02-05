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
)

target_compile_definitions(pnflow PRIVATE -DRELEASE_DATE="${RELEASE_DATE}")

install(TARGETS pnflow
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    ${RUNTIME_DEPENDENCIES}
)
