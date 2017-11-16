#!/bin/bash
# =============================================================================
# GNU OCTAVE INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 16th, 2017

# PURPOSE:
#  This script automates the installation and configuration of GNU Octave 4.2.1
#  for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is
#  to provide a means of achieving a consistent installation across all targets.

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
#  GNU Octave Installation and Configuration Script
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
  echo -ne ' \033[31mERROR:\033[0m Octave install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                      OCTAVE INSTALL SCRIPT :: M.J. Riblett                     \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of GNU Octave 4.2.1"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Installdeveloper tools
# -----------------------------------------------------------------------------
echo -e "\n\033[32m Building and installing Octave\033[0m"
STATUS=$?
mkdir -p /repo/octave > /dev/null 2>&1
cd /repo/octave

echo -e " - Installing Octave distribution dependencies"
apt-get build-dep octave -y > /dev/null 2>&1
apt-get install libqt4-dev libqt4-opengl-dev librsvg2-bin unixodbc-dev \
                icoutils libosmesa6 libosmesa6-dev ocl-icd-libopencl1 \
                mesa-opencl-icd libglib2.0-0 libglib2.0-data libglib2.0-bin \
                libglib2.0-dev libglibmm-2.4-1v5 libglibmm-2.4-dev \
                libgtkmm-3.0-dev libportaudio2 libportaudiocpp0 \
                portaudio19-dev libsndfile1 libsndfile1-dev \
                sndfile-programs -y > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error installing distribution dependencies."
  exit
fi

echo -e " - Downloading Octave 4.2.1"
wget https://ftp.gnu.org/gnu/octave/octave-4.2.1.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error downloading source for Octave."
  exit
fi

echo -e " - Extracting Octave sources to repository"
tar -xvzf octave-4.2.1.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error extracting source for Octave."
  exit
fi

echo -e " - Configuring Octave build for Jetson TX2  (May take a while)"
cd - > /dev/null 2>&1; cd /repo/octave/octave-4.2.1
touch build.log > /dev/null 2>&1
./configure --prefix=/usr/local CFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' CXXFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' FFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' --with-hdf5-includedir=/usr/include/hdf5/serial --with-hdf5-libdir=/usr/lib/aarch64-linux-gnu/hdf5/serial JAVA_HOME="/usr/lib/jvm/java-8-openjdk-arm64" > build.log 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error configuring build for Octave."
  exit
fi

echo -e " - Building and installing Octave           (Go get a coffee)"
make -j3 >> build.log 2>&1
make install >> build.log 2>&1
cd - > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error building and installing Octave."
  exit
fi

echo -e '\n Installation Finished!\n'


# =============================================================================
