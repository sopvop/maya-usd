# - Find python libraries
# This module finds the libraries corresponding to the Python interpreter
# FindPython provides.
# This code sets the following variables:
#
#  PYTHONLIBS_FOUND           - have the Python libs been found
#  PYTHON_PREFIX              - path to the Python installation
#  PYTHON_LIBRARIES           - path to the python library
#  PYTHON_INCLUDE_DIRS        - path to where Python.h is found
#  PYTHON_MODULE_EXTENSION    - lib extension, e.g. '.so' or '.pyd'
#  PYTHON_MODULE_PREFIX       - lib name prefix: usually an empty string
#  PYTHON_SITE_PACKAGES       - path to installation site-packages
#  PYTHON_IS_DEBUG            - whether the Python interpreter is a debug build
#
# Thanks to talljimbo for the patch adding the 'LDVERSION' config
# variable usage.

#=============================================================================
# Copyright 2001-2009 Kitware, Inc.
# Copyright 2012 Continuum Analytics, Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
# nor the names of their contributors may be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# # A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

# Checking for the extension makes sure that `LibsNew` was found and not just `Libs`.
if(PYTHONLIBS_FOUND AND PYTHON_MODULE_EXTENSION)
    return()
endif()

# On Mac, with Maya 2022+, the Python binaries link against a non-existent path
# maya2022/Maya.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python -> /Library/Frameworks/Python.framework/Versions/3.7/Python
# However, just using the mayapy executable is good enough for the build system
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    MESSAGE(STATUS "Setting Python_EXECUTABLE to MayaPy ${MAYA_PY_EXECUTABLE}")
    set(Python_EXECUTABLE ${MAYA_PY_EXECUTABLE})
endif()

# Use the Python module to find the python lib.
if(BUILD_WITH_PYTHON_3)
    find_package(Python ${BUILD_WITH_PYTHON_3_VERSION} EXACT REQUIRED COMPONENTS Interpreter Development)
else()
    find_package(Python 2.7 EXACT REQUIRED COMPONENTS Interpreter Development)
endif()

if(NOT Python_Interpreter_FOUND)
    set(PYTHONLIBS_FOUND FALSE)
    return ()
endif()

if (WIN32)
  set(PYTHON_MODULE_EXTENSION ".pyd")
else()
  set(PYTHON_MODULE_EXTENSION ".so")
endif()

set(PYTHONLIBS_FOUND TRUE)

