#!/bin/bash
# =============================================================================
# JETSON REPO USER INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 15th, 2017

# PURPOSE:
#  This script automates the granting of permissions to an existing user for
#  repo access on a Jetson TX2 (JetPack 3.1). The purpose of this script is to
#  provide an means of achieving a consistent installation across all targets.

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
#  Jetson Root User Installation and Configuration Script
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

# Ensure running with root privledges
if [ "$(whoami)" != "root" ]; then
  echo -ne ' \033[31mERROR:\033[0m Configuration script must be run with root privledges.\n'
  exit 1
fi

# Ensure repo group/directory already exists
if [ ! -d "/repo" ]; then
  echo -ne ' \033[31mERROR:\033[0m Repository directory or group does not exist.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                    REPO USER CONFIG SCRIPT :: M.J. Riblett                     \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration of an existing user for repo access"
echo -e " on an NVIDIA Jetson TX2 running JetPack.  The purpose of this script is to"
echo -e " provide an means of achieving a consistent configuration across all targets."
echo -e "\n >> Press [ENTER] to proceed or [Ctrl+C] to quit."
read input


# Query for user name
# -----------------------------------------------------------------------------
read -p 'User to add to repository group: ' uservar


# Error checking
# -----------------------------------------------------------------------------
# 1. Does user already exist?
user_new=$(id -u ${uservar} > /dev/null 2>&1; echo $?)
if [ ${user_new} == 1 ]; then
  echo -ne ' \033[31mERROR:\033[0m User does not exist.\n'
  exit 1
fi


# Add user with system wrapper and add to sudo group
# -----------------------------------------------------------------------------
usermod -aG repo ${uservar}


# =============================================================================
