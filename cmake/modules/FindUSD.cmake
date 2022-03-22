find_package(pxr REQUIRED)

find_path(USD_INCLUDE_DIR
    NAMES
        pxr/pxr.h
    HINTS
        ${PXR_USD_LOCATION}
        $ENV{PXR_USD_LOCATION}
        ${pxr_INCLUDE_DIR}
    PATH_SUFFIXES
        include
    DOC
        "USD Include directory"
)

if(DEFINED PXR_VERSION)
    # Starting in core USD 21.05, pxrConfig.cmake provides the various USD
    # version numbers as CMake variables, in which case PXR_VERSION should have
    # been defined, along with the major, minor, and patch version numbers, so
    # there is no need to extract them from the pxr/pxr.h header file anymore.
    # The only thing we need to do is assemble the USD_VERSION version string.
    set(USD_VERSION ${PXR_MAJOR_VERSION}.${PXR_MINOR_VERSION}.${PXR_PATCH_VERSION})
elseif(USD_INCLUDE_DIR AND EXISTS "${USD_INCLUDE_DIR}/pxr/pxr.h")
    foreach(_usd_comp MAJOR MINOR PATCH)
        file(STRINGS
            "${USD_INCLUDE_DIR}/pxr/pxr.h"
            _usd_tmp
            REGEX "#define PXR_${_usd_comp}_VERSION .*$")
        string(REGEX MATCHALL "[0-9]+" USD_${_usd_comp}_VERSION ${_usd_tmp})
    endforeach()
    set(USD_VERSION ${USD_MAJOR_VERSION}.${USD_MINOR_VERSION}.${USD_PATCH_VERSION})
    math(EXPR PXR_VERSION "${USD_MAJOR_VERSION} * 10000 + ${USD_MINOR_VERSION} * 100 + ${USD_PATCH_VERSION}")
endif()

# Get the boost version from the one built with USD
if(USD_INCLUDE_DIR)
    file(GLOB _USD_VERSION_HPP_FILE "${USD_INCLUDE_DIR}/boost-*/boost/version.hpp")
    list(LENGTH _USD_VERSION_HPP_FILE found_one)
    if(${found_one} STREQUAL "1")
        list(GET _USD_VERSION_HPP_FILE 0 USD_VERSION_HPP)
        file(STRINGS
            "${USD_VERSION_HPP}"
            _usd_tmp
            REGEX "#define BOOST_VERSION .*$")
        string(REGEX MATCH "[0-9]+" USD_BOOST_VERSION ${_usd_tmp})
        unset(_usd_tmp)
        unset(_USD_VERSION_HPP_FILE)
        unset(USD_VERSION_HPP)
    endif()
endif()

message(STATUS "USD include dir: ${USD_INCLUDE_DIR}")
message(STATUS "USD library dir: ${USD_LIBRARY_DIR}")
message(STATUS "USD version: ${USD_VERSION}")
if(DEFINED USD_BOOST_VERSION)
    message(STATUS "USD Boost::boost version: ${USD_BOOST_VERSION}")
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(USD
    REQUIRED_VARS
        USD_INCLUDE_DIR
        USD_VERSION
        PXR_VERSION
    VERSION_VAR
        USD_VERSION
)
