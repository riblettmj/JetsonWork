#!/bin/bash
# =============================================================================
# PYTHON INSTALLATION AND CONFIGURATION SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   October 4th, 2017

# PURPOSE:
#  This script automates the installation and configuration of Python 2.7.x for
#  a Debian-based Linux system (i.e. Ubuntu).  The purpose of this script is to
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
#  Python Installation and Configuration Script
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
  echo -ne ' \033[31mERROR:\033[0m Python install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                     PYTHON INSTALL SCRIPT :: M.J. Riblett                      \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of Python 2.7.x for"
echo -e " a Debian-based Linux system (i.e. Ubuntu).  The purpose of this script is to"
echo -e " provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input

# Error checking
# -----------------------------------------------------------------------------
if [ ! -f python_packages.txt ]; then
  echo -e "\n\033[31m ERROR:\033[0m Package list file does not exist in working directory."
  exit 1
fi

# Install Distribution Python
# -----------------------------------------------------------------------------
echo -ne '\033[32m Installing and configuring Python\033[0m\n'
STATUS=$?
echo -ne ' - Installing distribution Python\n'
apt-get install python-dev ipython ipython-notebook python-sip pyro python-setuptools -y > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -ne "  \033[31m FAILED:\033[0m Error installing distribution Python\n"
fi

# Install pip and update required components for secure connections
# -----------------------------------------------------------------------------
echo -ne ' - Installing pip and updating security requirements\n'
apt-get install python-pip -y > /dev/null 2>&1 && \
pip install --upgrade --force pip > /dev/null 2>&1 && \
pip install --upgrade --force pip > /dev/null 2>&1 && \
apt-get remove python-pip python-six python-openssl -y > /dev/null 2>&1 && \
pip install --upgrade --force setuptools > /dev/null 2>&1 && \
apt-get install libffi-dev libssl-dev -y > /dev/null 2>&1 && \
pip install --upgrade --force pyopenssl ndg-httpsclient pyasn1 > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -ne "  \033[31m FAILED:\033[0m Error installing pip and updating security requirements\n"
fi

# Install packages for development environment                        (via pip)
# -----------------------------------------------------------------------------
echo -ne ' - Installing packages for development environment  (This may take a while...)\n'
pip install --upgrade -r python_packages.txt > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo -ne "  \033[31m FAILED:\033[0m Error installing packages for development environment\n"
fi

# Update pip-installed packages
# -----------------------------------------------------------------------------
if [ "$STATUS" -eq 0 ]; then
  echo -ne ' - Updating pip-installed packages  (This may take a while...)\n'
  pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --upgrade --force --ignore-installed six > /dev/null 2>&1
  #STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    echo -e "\n\033[32m SUCCESS:\033[0m Installed and configured Python"
  else
    echo -e "\n\033[31m FAILED:\033[0m Error installing or configuring Python"
  fi
else
  echo -e "\n\033[31m FAILED:\033[0m Error installing or configuring Python"
fi

# =============================================================================
