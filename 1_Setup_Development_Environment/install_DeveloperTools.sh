#!/bin/bash
# =============================================================================
# DEVELOPER TOOLS INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   November 15th, 2017

# PURPOSE:
#  This script automates the installation and configuration of development tools
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
#  Developer Tools Installation and Configuration Script
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
  echo -ne ' \033[31mERROR:\033[0m Dev tools install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                 DEVELOPER TOOLS INSTALL SCRIPT :: M.J. Riblett                 \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of developer tools"
echo -e " for Debian-based Linux systems (i.e. Ubuntu).  The purpose of this script is"
echo -e " to provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input


# Update OS and application packages before starting
# -----------------------------------------------------------------------------
echo -ne '\033[32m Updating operating system and application packages\033[0m\n'
echo -e "\033[33m - Performing update operations via Aptitude\033[0m"
echo "   Updating list of available packages..."; apt-get update -qq
echo "   Performing OS distribution upgrade..."; apt-get dist-upgrade -qq -y
echo "   Removing obsolete and unused packages..."; apt-get autoremove -qq -y
echo "   Cleaning package listing..."; apt-get clean -qq -y
echo "   Updating package listing for current distribution..."; apt-get update -qq


# Installdeveloper tools
# -----------------------------------------------------------------------------
echo -ne '\n\033[32m Installing developer tools\033[0m\n'
STATUS=$?
echo -e "\033[33m - Installing standard toolset for Jetson TX2\033[0m"
apt-get install avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan \
                ntp nfs-common openssh-server libssl-dev msmtp msmtp-mta \
                ca-certificates build-essential unzip cmake cmake-curses-gui \
                git subversion mercurial gengetopt htop tmux bison valkyrie \
                valgrind libpcre3-dev libglm-dev libnetcdf-dev libfreetype6 \
                libfreetype6-dev libblas-dev libblas-doc libblas3 \
                libatlas-base-dev libatlas3-base libblas-test \
                libopenblas-base libopenblas-dev liblapack-dev \
                gcc-4.9 g++-4.9 gfortran-4.9 pbzip2 pigz p7zip pixz parallel \
                doxygen doxygen-latex graphviz gnuplot-qt \
                libxt-dev libgdcm2-dev libpq-dev libhdf5-doc \
                libhdf5-serial-dev hdf5-tools hdfview \
                libglew-dev libtiff5-dev zlib1g-dev libjpeg-dev libpng12-dev \
                libjasper-dev libavcodec-dev libavformat-dev libavutil-dev \
                libpostproc-dev libswscale-dev libeigen3-dev libtbb-dev \
                libgtk2.0-dev pkg-config cvs bzr bzrtools -y > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -ne "  \033[31m FAILED:\033[0m Error installing developer tools\n"
fi

echo -e '\n Installation Finished!\n'


# =============================================================================
