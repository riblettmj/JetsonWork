#!/bin/bash
# =============================================================================
# VTK INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 16th, 2017

# PURPOSE:
#  This script automates the installation and configuration of the visualization
#  toolkit (VTK) for Debian-based Linux systems (i.e. Ubuntu).  The purpose of
#  this script is to provide a means of achieving a consistent installation
#  across all targets.

# SYSTEM SCOPE:
#  The following commands were designed for and tested on Ubuntu 16.04.03 LTS
#  (Debian-based Linux) and have been found to work.  While many of the
#  commands in this script will work on similar Linux and UNIX machines, some
#  will require adjustment or replacement when using on an unsupported target.
#  In particular, the package names and installation commands may vary quite
#  considerably between operating systems -- it would behoove the end user to
#  review the commands below and verify their compatibility prior to installing
#  on a non-Ubuntu system.

# LICENSE AND COPYRIGHT NOTICE:
#  VTK Installation and Configuration Script
#  Copyright (C) 2017 Matthew J. Riblett
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
#  The author may be contacted via email: matt@riblett.io


# =============================================================================

# Initialization and argument parsing
# -----------------------------------------------------------------------------

# System configuration options
# N/A

# Ensure running with root privledges
if [ "$(whoami)" != "root" ]; then
  echo -ne ' \033[31mERROR:\033[0m VTK install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                       VTK INSTALL SCRIPT :: M.J. Riblett                       \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of VTK libraries"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Install VTK
# -----------------------------------------------------------------------------
echo -e "\n\033[32m Building and installing VTK Libraries\033[0m"
STATUS=$?
mkdir -p /repo/vtk > /dev/null 2>&1
cd /repo/vtk > /dev/null 2>&1

echo -e " - Installing VTK distribution dependencies"
apt-get install libxt-dev libgdcm2-dev libpq-dev -y > /dev/null 2>&1
# QT5
apt-get install qtbase5-dev qtconnectivity5-dev qttools5-dev qtmultimedia5-dev \
                libqt5opengl5-dev qtpositioning5-dev qtdeclarative5-dev \
                qtscript5-dev libqt5sensors5-dev libqt5serialport5-dev \
                libqt5svg5-dev libqt5bluetooth5 libqt5concurrent5 \
                libqt5contacts5 libqt5core5a libqt5dbus5 libqt5designer5 \
                libqt5designercomponents5 libqt5feedback5 libqt5gui5 \
                libqt5help5 libqt5location5 libqt5multimedia5 libqt5network5 \
                libqt5nfc5 libqt5opengl5 libqt5organizer5 libqt5positioning5 \
                libqt5printsupport5 libqt5publishsubscribe5 libqt5qml5 \
                libqt5quick5 libqt5quickparticles5 libqt5quicktest5 \
                libqt5quickwidgets5 libqt5script5 libqt5scripttools5 \
                libqt5sensors5 libqt5serialport5 libqt5serviceframework5 \
                libqt5sql5 libqt5svg5 libqt5systeminfo5 libqt5test5 \
                libqt5webkit5-dev libqt5websockets5-dev libqt5x11extras5-dev \
                libqt5xmlpatterns5-dev libqt5webkit5 libqt5websockets5 \
                libqt5widgets5 libqt5x11extras5 libqt5xml5 libqt5xmlpatterns5 \
                -y > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error install dependencies for VTK."
  exit
fi

echo -e " - Downloading VTK 8.0"
git clone --branch v8.0.0 https://github.com/Kitware/VTK.git --depth 1 > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error downloading source for VTK."
  exit
fi

echo -e " - Setting up build directory"
mkdir vtk_build_800 > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error setting up build directory for VTK."
  exit
fi

echo -e " - Configuring VTK build for Jetson TX2   (May take a while)"
cd - > /dev/null 2>&1; cd /repo/vtk/vtk_build_800 > /dev/null 2>&1
touch build.log > /dev/null 2>&1
cmake   -DCMAKE_CXX_FLAGS:STRING='-Wall -fPIC -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' \
        -DCMAKE_C_FLAGS:STRING='-Wall -fPIC -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' \
        -DBUILD_DOCUMENTATION:BOOL=OFF \
        -DBUILD_EXAMPLES:BOOL=OFF \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_TESTING:BOOL=OFF \
        -DCMAKE_BACKWARDS_COMPATIBILITY:STRING=2.4 \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr/local \
        -DCTEST_TEST_TIMEOUT:STRING=3600 \
        -DQt5Core_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5Core \
        -DQt5Gui_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5Gui \
        -DQt5Sql_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5Sql \
        -DQt5UiPlugin_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5UiPlugin \
        -DQt5Widgets_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5Widgets \
        -DQt5X11Extras_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5X11Extras \
        -DQt5_DIR:PATH=/usr/lib/aarch64-linux-gnu/cmake/Qt5 \
        -DVTK_ANDROID_BUILD:BOOL=OFF \
        -DVTK_EXTRA_COMPILER_WARNINGS:BOOL=OFF \
        -DVTK_GLEXT_FILE:FILEPATH=/repo/vtk/VTK/Utilities/ParseOGLExt/headers/glext.h \
        -DVTK_GLXEXT_FILE:FILEPATH=/repo/vtk/VTK/Utilities/ParseOGLExt/headers/glxext.h \
        -DVTK_Group_Imaging:BOOL=ON \
        -DVTK_Group_MPI:BOOL=OFF \
        -DVTK_Group_Qt:BOOL=ON \
        -DVTK_Group_Rendering:BOOL=ON \
        -DVTK_Group_StandAlone:BOOL=ON \
        -DVTK_Group_Tk:BOOL=OFF \
        -DVTK_Group_Views:BOOL=ON \
        -DVTK_Group_Web:BOOL=ON \
        -DVTK_IOS_BUILD:BOOL=OFF \
        -DVTK_PYTHON_VERSION:STRING=2 \
        -DVTK_QT_VERSION:STRING=5 \
        -DVTK_RENDERING_BACKEND:STRING=OpenGL2 \
        -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=OpenMP \
        -DVTK_USE_LARGE_DATA:BOOL=OFF \
        -DVTK_WGLEXT_FILE:FILEPATH=/repo/vtk/VTK/Utilities/ParseOGLExt/headers/wglext.h \
        -DVTK_WRAP_JAVA:BOOL=OFF \
        -DVTK_WRAP_PYTHON:BOOL=ON \
        -DVTK_WRAP_TCL:BOOL=OFF ../VTK > build.log 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error configuring build for VTK."
  exit
fi

echo -e " - Building and installing VTK            (Get a coffee)"
make -j3 >> build.log 2>&1
make install >> build.log 2>&1
ldconfig > /dev/null 2>&1
cd - > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error building and installing the VTK."
  exit
fi

echo -e " - Adding VTK to Python path"
echo '\nexport PYTHONPATH=$PYTHONPATH:/repo/vtk/vtk_build_800/Wrapping:/repo/vtk/vtk_build_800/lib' >> /etc/profile


echo -e '\n Installation Finished!   (Python VTK available at next login)\n'


# =============================================================================
