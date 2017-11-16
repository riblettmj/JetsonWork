#!/bin/bash
# =============================================================================
# SWIG INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 16th, 2017

# PURPOSE:
#  This script automates the installation and configuration of SWIG 3.0.10
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
#  SWIG Installation and Configuration Script
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
  echo -ne ' \033[31mERROR:\033[0m SWIG install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                       SWIG INSTALL SCRIPT :: M.J. Riblett                      \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of SWIG 3.0.10"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Installdeveloper tools
# -----------------------------------------------------------------------------
echo -e "\n\033[32m Building and installing SWIG\033[0m"
STATUS=$?
mkdir -p /repo/swig > /dev/null 2>&1
cd /repo/swig

echo -e " - Downloading SWIG 3.0.10"
wget http://downloads.sourceforge.net/project/swig/swig/swig-3.0.10/swig-3.0.10.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error downloading source for SWIG."
  exit
fi

echo -e " - Extracting SWIG sources to repository"
tar -xvzf swig-3.0.10.tar.gz > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error extracting source for SWIG."
  exit
fi

echo -e " - Configuring SWIG build for Jetson TX2  (May take a while)"
cd - > /dev/null 2>&1; cd /repo/swig/swig-3.0.10/
./configure > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error configuring build for SWIG."
  exit
fi

echo -e " - Building and installing SWIG           (Go get a coffee)"
make -j3 > /dev/null 2>&1
make install > /dev/null 2>&1
cd - > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error building and installing SWIG."
  exit
fi

echo -e '\n Installation Finished!\n'


# =============================================================================
