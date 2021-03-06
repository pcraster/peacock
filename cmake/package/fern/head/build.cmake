set(fern_prefix ${peacock_package_prefix})


set(fern_cmake_args ${fern_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${fern_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(fern_cmake_args ${fern_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()

if(fern_build_fern_algorithm)
    set(fern_cmake_args ${fern_cmake_args}
        -DFERN_BUILD_ALGORITHM:BOOL=TRUE)
endif()

if(fern_build_fern_documentation)
    set(fern_cmake_args ${fern_cmake_args}
        -DFERN_BUILD_DOCUMENTATION:BOOL=TRUE)
endif()

if(fern_build_fern_test)
    set(fern_cmake_args ${fern_cmake_args}
        -DFERN_BUILD_TEST:BOOL=TRUE)
endif()

if(build_boost)
    set(fern_dependencies ${fern_dependencies} boost-${boost_version})
    set(fern_cmake_find_root_path ${fern_cmake_find_root_path}
        ${boost_prefix})
endif()

if(fern_cmake_find_root_path)
    set(fern_cmake_args ${fern_cmake_args}
        -DCMAKE_FIND_ROOT_PATH=${fern_cmake_find_root_path})
endif()

add_custom_target(fern-${fern_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments "")

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(fern_target fern-${fern_version}-${build_type})

    ExternalProject_Add(${fern_target}
        DEPENDS ${fern_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${fern_git_repository}
        GIT_TAG ${fern_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${fern_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${fern_patch_command}
        # TODO This requires updated path settings.
        # TEST_BEFORE_INSTALL 1
    )

    add_dependencies(fern-${fern_version} ${fern_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(fern-${fern_version}-Debug fern-${fern_version}-Release)
endif()
