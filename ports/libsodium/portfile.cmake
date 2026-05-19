include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KomodoPlatform/libsodium
    REF 1.0.18
    SHA512 269bda48307db8b7b4bd734704bc49add71f947704109416f9e9d2304bc60a39fa33ae201ccac54721bdce7d521067fc3d75022044557ab6cb37890b03505411
    HEAD_REF master
)

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
    ${SOURCE_PATH}/CMakeLists.txt
    COPYONLY
)

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/sodiumConfig.cmake.in
    ${SOURCE_PATH}/sodiumConfig.cmake.in
    COPYONLY
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets(
    CONFIG_PATH lib/cmake/unofficial-sodium
    TARGET_PATH share/unofficial-sodium
)

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include
)

file(REMOVE ${CURRENT_PACKAGES_DIR}/include/Makefile.am)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string(
        ${CURRENT_PACKAGES_DIR}/include/sodium/export.h
        "#ifdef SODIUM_STATIC"
        "#if 1 //#ifdef SODIUM_STATIC"
    )
endif ()

configure_file(
    ${SOURCE_PATH}/LICENSE
    ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright
    COPYONLY
)

#vcpkg_test_cmake(PACKAGE_NAME unofficial-sodium)
