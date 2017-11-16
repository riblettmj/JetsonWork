#!/bin/bash
# =============================================================================
# TORCH7 INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 16th, 2017

# PURPOSE:
#  This script automates the installation and configuration of Torch7 and LUA
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
#  Torch7 Installation and Configuration Script
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
if [ "$(whoami)" == "root" ]; then
  echo -ne ' \033[31mERROR:\033[0m Torch7 install script must be run without root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                      TORCH7 INSTALL SCRIPT :: M.J. Riblett                     \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of Torch7 and LUA"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Install Torch7
# -----------------------------------------------------------------------------
echo -e "\n\033[32m Building and installing Torch7\033[0m"
STATUS=$?

echo -e " - Downloading Torch7"
git clone https://github.com/torch/distro.git /repo/torch --recursive > /dev/null 2>&1
cd /repo/torch > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error downloading source for Torch7."
  exit
fi

echo -e " - Installing Torch7 dependencies"
/bin/bash /repo/torch/install-deps > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error installing dependencies for Torch7."
  exit
fi

echo -e " - Building and installing Torch7    (Go get a coffee)"
/bin/bash /repo/torch/install.sh
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -e "\033[31m   FAILED: \033[0m Error building and installing Torch7."
  exit
fi

echo -e '\n Installation Finished!\n'


# =============================================================================
