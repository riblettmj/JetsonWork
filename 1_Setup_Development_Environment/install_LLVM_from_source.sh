#!/bin/bash
# ==============================================================================
# LLVM INSTALL SCRIPT:
#  Written By:  Matthew J. Riblett
#  Rev. Date:   October 25th, 2017

# PURPOSE:
#  This script automates the configuration and installation of the LLVM 5.0.0
#  compiler infrastructure on a UNIX system.  The purpose of this script is to
#  provide an means of achieving a consistent installation across all targets.

# SYSTEM SCOPE:
#  The following commands were designed for and tested on Ubuntu 16.04.02 LTS
#  (Debian-based Linux) and have been found to work.  While many of the
#  commands in this script will work on similar Linux and UNIX machines, some
#  will require adjustment or replacement when using on an unsupported target.
#  In particular, the package names and installation commands may vary quite
#  considerably between operating systems -- it would behoove the end user to
#  review the commands below and verify their compatibility prior to installing
#  on a non-Ubuntu system.

# LICENSE AND COPYRIGHT NOTICE:
#  LLVM Installation Helper Script
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


# ==============================================================================

# Initialization and argument parsing
# ------------------------------------------------------------------------------

# System configuration options
threads=0                               # Default to automatic subset size
workingPath=`pwd -P`                    # Set working path location

#  Pull command parameters for application execution
while getopts n:p: option; do
  case ${option} in
    "p") workingPath="$OPTARG";;                    # Working PATH
    "n") threads="$OPTARG";;				        # Parse number of threads
    "?") echo "Unknown argument."; exit 1;;         # Unknown argument flag
    *) 	 echo "Errors while initializing.";;        # Unknown errors
  esac
done

# Ensure running with root privledges
if [ "$(whoami)" != "root" ]; then
  echo -ne ' \033[31mERROR:\033[0m LLVM install script must be run with root privledges.\n'
  exit 1
fi

#  Announce script
echo -e "\n\033[42m                                                                                \033[0m"
echo -e "\033[47;30m                     LLVM INSTALL SCRIPT :: M.J.Riblett                         \033[0m"
echo -e "\033[42m                                                                                \033[0m"
echo -e "\n This script automates the configuration and installation of the LLVM 5.0.0"
echo -e " compiler infrastructure on a UNIX system.  The purpose of this script is to"
echo -e " provide an means of achieving a consistent installation across all targets."
echo -e "\n >> Press [ENTER] to proceed with installation or [Ctrl+C] to quit."
read input

# Error checking
# ------------------------------------------------------------------------------
# 2. Confirm working path
echo -ne " - Confirm build path is ${workingPath}: [y]/n  "
read check
echo -en '\033[1A'
if [[ $check == y* ]] || [[ $check == Y* ]] || [[ $check == "" ]]; then
  echo -ne '\n'
else
  echo -ne '\n   Assign new build path:  '
  read workingPath
  echo -ne '\033[1A\n'
  if [ "$workingPath" == "" ]; then
    echo -ne '\n   \033[31mFAILED TO SET WORKING PATH!\033[0m\n'
    exit
  fi
fi

# 3. Validity of working path
if [ ! -d $workingPath ]; then
  mkdir -p $workingPath
  if [ ! -d $workingPath ]; then
    echo -ne '\n   \033[31mWORKING PATH DOES NOT EXIST!\033[0m\n'
    exit
  fi
fi

# 4. Set threadspace as necessary
if [ ${threads} -le 0 ]; then
  threads=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
  echo -ne " - Automatic allocation of build threads: [${threads}]\n"
else
  echo -ne " - Manual allocation of build threads: [${threads}]\n"
fi


# Download LLVM source and setup build tree
# ------------------------------------------------------------------------------
echo -ne '\n\033[32m Downloading required source files\033[0m\n'
cd ${workingPath}
mkdir -p llvm && cd llvm > /dev/null 2>&1
mkdir -p llvm-5.0.0.build > /dev/null 2>&1
echo -ne ' - Downloading LLVM core sources\n'
wget http://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz > /dev/null 2>&1
tar xf llvm-5.0.0.src.tar.xz; rm llvm-5.0.0.src.tar.xz > /dev/null 2>&1
cd llvm-5.0.0.src > /dev/null 2>&1


# Download and extract tool dependency sources
# ------------------------------------------------------------------------------
cd tools > /dev/null 2>&1
echo -ne ' - Downloading Clang sources\n'
wget http://releases.llvm.org/5.0.0/cfe-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p clang && tar xf cfe-5.0.0.src.tar.xz -C clang --strip-components=1 > /dev/null 2>&1
rm cfe-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading LDD sources\n'
wget http://releases.llvm.org/5.0.0/lld-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p lld && tar xf lld-5.0.0.src.tar.xz -C ldd --strip-components=1 > /dev/null 2>&1
rm lld-5.0.0.src.tar.xz > /dev/null 2>&1


# Download and extract project dependency sources
# ------------------------------------------------------------------------------
cd ../projects
echo -ne ' - Downloading Compiler-RT sources\n'
wget http://releases.llvm.org/5.0.0/compiler-rt-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p compiler-rt && tar xf compiler-rt-5.0.0.src.tar.xz -C compiler-rt --strip-components=1 > /dev/null 2>&1
rm compiler-rt-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading libCXX sources\n'
wget http://releases.llvm.org/5.0.0/libcxx-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p libcxx && tar xf libcxx-5.0.0.src.tar.xz -C libcxx --strip-components=1 > /dev/null 2>&1
rm libcxx-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading libCXX-ABI sources\n'
wget http://releases.llvm.org/5.0.0/libcxxabi-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p libcxxabi && tar xf libcxxabi-5.0.0.src.tar.xz -C libcxxabi --strip-components=1 > /dev/null 2>&1
rm libcxxabi-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading libunwind sources\n'
wget http://releases.llvm.org/5.0.0/libunwind-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p libunwind && tar xf libunwind-5.0.0.src.tar.xz -C libunwind --strip-components=1 > /dev/null 2>&1
rm libunwind-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading LDDB sources\n'
wget http://releases.llvm.org/5.0.0/lldb-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p lldb && tar xf lldb-5.0.0.src.tar.xz -C lddb --strip-components=1 > /dev/null 2>&1
rm lldb-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading OpenMP bindings sources\n'
wget http://releases.llvm.org/5.0.0/openmp-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p openmp && tar xf openmp-5.0.0.src.tar.xz -C openmp --strip-components=1 > /dev/null 2>&1
rm openmp-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading Polly sources\n'
wget http://releases.llvm.org/5.0.0/polly-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p polly && tar xf polly-5.0.0.src.tar.xz -C polly --strip-components=1 > /dev/null 2>&1
rm polly-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading Clang Tools Extra sources\n'
wget http://releases.llvm.org/5.0.0/clang-tools-extra-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p clang-tools-extra && tar xf clang-tools-extra-5.0.0.src.tar.xz -C clang-tools-extra --strip-components=1 > /dev/null 2>&1
rm clang-tools-extra-5.0.0.src.tar.xz > /dev/null 2>&1

echo -ne ' - Downloading LLVM test suite sources\n'
wget http://releases.llvm.org/5.0.0/test-suite-5.0.0.src.tar.xz > /dev/null 2>&1
mkdir -p test-suite && tar xf test-suite-5.0.0.src.tar.xz -C test-suite --strip-components=1 > /dev/null 2>&1
rm test-suite-5.0.0.src.tar.xz > /dev/null 2>&1


# Configure LLVM build
# ------------------------------------------------------------------------------
echo -ne '\033[32m Configuring LLVM build\033[0m\n'
cd ../../llvm-5.0.0.build > /dev/null 2>&1
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../llvm-5.0.0.src/ > /dev/null 2>&1


# Build and Install
# ------------------------------------------------------------------------------
echo -ne '\033[32m Building and installing LLVM\033[0m\n'
echo -ne ' - Compiling LLVM core and dependencies\n'
make -j${threads} > /dev/null 2>&1
STATUS=$?
if [ "$STATUS" -eq 0 ]; then
  echo -ne ' - Installing LLVM to target\n'
  sudo make install > /dev/null 2>&1
  STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    echo -e "\n\033[32m SUCCESS: \033[0m Installed LLVM 5.0.0."
  else
    echo -e "\n\033[31m FAILED: \033[0m Error installing LLVM 5.0.0."
  fi
else
  echo -e "\n\033[31m FAILED: \033[0m Error building LLVM 5.0.0."
fi

# ==============================================================================
