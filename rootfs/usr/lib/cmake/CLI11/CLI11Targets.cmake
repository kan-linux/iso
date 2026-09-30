if(NOT TARGET CLI11::CLI11)
    add_library(CLI11::CLI11 INTERFACE IMPORTED)
    set_target_properties(CLI11::CLI11 PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/../../../include"
    )
endif()
