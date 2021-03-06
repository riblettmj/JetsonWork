#!/bin/bash
# =============================================================================
# JETSON CODE REPOSITORY DIRECTORY CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 15th, 2017

# PURPOSE:
#  This script automates the configuration of a code repository directory on a
#  Jetson TX2 (JetPack 3.1). The purpose of this script is to provide an means
#  of achieving a consistent installation across all targets.

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
#  Jetson Code Repository Directory Configuration Script
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

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                   REPOSITORY CONFIG SCRIPT :: M.J. Riblett                     \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration of a code repository directory"
echo -e " on an NVIDIA Jetson TX2 running JetPack.  The purpose of this script is to"
echo -e " provide an means of achieving a consistent configuration across all targets."
echo -e "\n >> Press [ENTER] to proceed or [Ctrl+C] to quit."
read input


# Make directory and configure permissions for current
# -----------------------------------------------------------------------------
mkdir -p /repo
groupadd repo
chgrp -R repo /repo
usermod -a -G repo $(whoami)


# =============================================================================
