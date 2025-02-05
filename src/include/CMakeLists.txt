add_library(utils INTERFACE)
target_include_directories(utils INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)
add_library(${CMAKE_PROJECT_NAME}::utils ALIAS utils)
