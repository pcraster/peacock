if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 123)
else()
    set(boost_url_md5 7fbd1890f571051f2a209681d57d486a)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})
