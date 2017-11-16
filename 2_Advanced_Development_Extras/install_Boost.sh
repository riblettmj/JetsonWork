#!/bin/bash
# =============================================================================
# BOOST LIBRARIES INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 16th, 2017

# PURPOSE:
#  This script automates the installation and configuration of BOOST Libraries
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
#  Boost Libraries Installation and Configuration Script
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
  echo -ne ' \033[31mERROR:\033[0m BOOST install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                 BOOST LIBRARIES INSTALL SCRIPT :: M.J. Riblett                 \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of BOOST libraries"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Installdeveloper tools
# -----------------------------------------------------------------------------
echo -e "\n\033[32m Building and installing BOOST C++ Libraries\033[0m"
STATUS=$?
mkdir -p /repo/boost > /dev/null 2>&1
cd /repo/boost

echo -e " - Downloading BOOST 1.65.1"
wget http://downloads.sourceforge.net/project/boost/boost/1.65.1/boost_1_65_1.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\t\033[31m   FAILED: \033[0m Error downloading source for BOOST C++ libraries."
  exit
fi

echo -e " - Extracting sources to repository"
tar -xvzf boost_1_65_1.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\t\033[31m   FAILED: \033[0m Error extracting source for BOOST C++ libraries."
  exit
fi

echo -e " - Configuring BOOST build for Jetson TX2"
cd - ; cd /repo/boost/boost_1_65_1/
./bootstrap.sh --prefix=/usr/local CFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' CXXFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' FFLAGS='-O3 -march=armv8-a+crc+crypto+fp+simd -mtune=cortex-a57' > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\t\033[31m   FAILED: \033[0m Error configuring build for BOOST C++ Libraries."
  exit
fi

echo -e " - Building and installing BOOST libraries"
./b2 --with=all -j3 install
ldconfig
cd -
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\t\033[31m   FAILED: \033[0m Error building and installing the BOOST C++ Libraries."
  exit
fi

echo -e '\n Installation Finished!\n'


# =============================================================================
