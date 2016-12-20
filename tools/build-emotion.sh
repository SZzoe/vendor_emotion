#!/bin/bash
#
# build-emotion.sh: the overarching build script for the ROM.
# Copyright (C) 2015 The PAC-ROM Project
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

usage() {
    echo -e "${bldblu}Usage:${bldcya}"
    echo -e "  build-emotion.sh [options] device"
    echo ""
    echo -e "${bldblu}  Options:${bldcya}"
    echo -e "    -a  Disable ADB authentication and set root access to Apps and ADB"
    echo -e "    -b  Build a single APK"
    echo -e "    -c# Cleaning options before build:"
    echo -e "        1 - Run make clean"
    echo -e "        2 - Run make installclean"
    echo -e "    -d  Build rom without ccache"
    echo -e "    -e# Extra build output options:"
    echo -e "        1 - Verbose build output"
    echo -e "        2 - Quiet build output"
    echo -e "    -i  Ignore minor errors during build"
    echo -e "    -j# Set number of jobs"
    echo -e "    -k  Rewrite roomservice after dependencies update"
    echo -e "    -l  Optimizations for devices with low-RAM"
    echo -e "    -o# Only build:"
    echo -e "        1 - Boot Image"
    echo -e "    -r  Reset source tree before build"
    echo -e "    -s# Sync options before build:"
    echo -e "        0 - Force sync"
    echo -e "        1 - Normal sync"
    echo -e "        2 - Make snapshot"
    echo -e "        3 - Restore previous snapshot, then snapshot sync"
    echo -e "    -w#  Log file options:"
    echo -e "        1 - Send warnings and errors to a log file"
    echo -e "        2 - Send all output to a log file"
    echo ""
    echo -e "${bldblu}  Example:${bldcya}"
    echo -e "    ./build-emotion.sh -c1 trltexx"
    echo -e "${rst}"
    exit 1
}


# Import Colors
. ./vendor/emotion/tools/colors
. ./vendor/emotion/tools/res/emotion_start


# EMOTION version
export EMOTION_VERSION_MAJOR="NG"
export EMOTION_VERSION_MINOR="beta32-r1"
export EMOTION_VERSION_MAINTENANCE="Unofficial"
# Acceptable maintenance versions are; Stable, Official, Nightly or Unofficial


# Default global variable values with preference to environmant.
if [ -z "${USE_CCACHE}" ]; then
    export USE_CCACHE=1
fi


# Maintenance logic
if [ -s ~/EMOTIONname ]; then
    export EMOTION_MAINTENANCE=$(cat ~/EMOTIONname)
else
    export EMOTION_MAINTENANCE="$EMOTION_VERSION_MAINTENANCE"
fi
if [ -z "$EMOTION_VERSION_MINOR" ]; then
    export EMOTION_VERSION="$EMOTION_VERSION_MAJOR $EMOTION_MAINTENANCE"
else
    export EMOTION_VERSION="$EMOTION_VERSION_MAJOR $EMOTION_VERSION_MINOR $EMOTION_MAINTENANCE"
fi


# Check directories
if [ ! -d ".repo" ]; then
    echo -e "${bldred}No .repo directory found.  Is this an Android build tree?${rst}"
    echo ""
    exit 1
fi
if [ ! -d "vendor/emotion" ]; then
    echo -e "${bldred}No vendor/emotion directory found.  Is this a EMOTION build tree?${rst}"
    echo ""
    exit 1
fi


# Figure out the output directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
thisDIR="${PWD##*/}"

if [ -n "${OUT_DIR_COMMON_BASE+x}" ]; then
    RES=1
else
    RES=0
fi


if [ $RES = 1 ];then
    export OUTDIR=$OUT_DIR_COMMON_BASE/$thisDIR
    echo -e "${bldcya}External out directory is set to: ${bldgrn}($OUTDIR)${rst}"
    echo ""
elif [ $RES = 0 ];then
    export OUTDIR=$DIR/out
    echo -e "${bldcya}No external out, using default: ${bldgrn}($OUTDIR)${rst}"
    echo ""
else
    echo -e "${bldred}NULL"
    echo -e "Error, wrong results! Blame the split screen!${rst}"
    echo ""
fi


# Get OS (Linux / Mac OS X)
IS_DARWIN=$(uname -a | grep Darwin)
if [ -n "$IS_DARWIN" ]; then
    CPUS=$(sysctl hw.ncpu | awk '{print $2}')
else
    CPUS=$(grep "^processor" /proc/cpuinfo -c)
fi


opt_adb=0
opt_build=0
opt_clean=0
opt_ccache=0
opt_extra=0
opt_jobs="$CPUS"
opt_kr=0
opt_ignore=0
opt_lrd=0
opt_only=0
opt_reset=0
opt_sync=9
opt_log=0

while getopts "abc:de:ij:klo:rs:w:" opt; do
    case "$opt" in
    a) opt_adb=1 ;;
    b) opt_build=1 ;;
    c) opt_clean="$OPTARG" ;;
    d) opt_ccache=1 ;;
    e) opt_extra="$OPTARG" ;;
    i) opt_ignore=1 ;;
    j) opt_jobs="$OPTARG" ;;
    k) opt_kr=1 ;;
    l) opt_lrd=1 ;;
    o) opt_only="$OPTARG" ;;
    r) opt_reset=1 ;;
    s) opt_sync="$OPTARG" ;;
    w) opt_log="$OPTARG" ;;
    *) usage
    esac
done

shift $((OPTIND-1))
if [ "$#" -ne 1 ]; then
    usage
fi
device="$1"


# Ccache options
if [ "$opt_ccache" -eq 1 ]; then
    echo -e "${bldcya}Ccache not be used in this build${rst}"
    unset USE_CCACHE
    echo ""
fi


# Emotion device dependencies
echo -e "${bldcya}Looking for Emotion product dependencies${bldgrn}"
if [ "$opt_kr" -ne 0 ]; then
    vendor/emotion/tools/getdependencies.py "$device" "$opt_kr"
else
    vendor/emotion/tools/getdependencies.py "$device"
fi
echo -e "${rst}"


# Check if last build was made ignoring errors
# Set if unset
if [ -f ".ignore_err" ]; then
   : ${TARGET_IGNORE_ERRORS:=$(cat .ignore_err)}
else
   : ${TARGET_IGNORE_ERRORS:=false}
fi

export TARGET_IGNORE_ERRORS

if [ "$TARGET_IGNORE_ERRORS" == "true" ]; then
   opt_clean=1
   echo -e "${bldred}Last build ignored errors. Cleaning Out${rst}"
   unset TARGET_IGNORE_ERRORS
   echo -e "false" > .ignore_err
fi


# Cleaning out directory
if [ "$opt_clean" -eq 1 ]; then
    echo -e "${bldcya}Cleaning output directory${rst}"
    make clean >/dev/null
    echo -e "${bldcya}Output directory is: ${bldgrn}Clean${rst}"
    echo ""
elif [ "$opt_clean" -eq 2 ]; then
    . build/envsetup.sh
    lunch "emotion_$device-userdebug"
    make installclean >/dev/null
    echo -e "${bldcya}Output directory is: ${bldred}Dirty${rst}"
    echo ""
else
    if [ -d "$OUTDIR/target" ]; then
        echo -e "${bldcya}Output directory is: ${bldylw}Untouched${rst}"
        echo ""
    else
        echo -e "${bldcya}Output directory is: ${bldgrn}Clean${rst}"
        echo ""
    fi
fi

# Build APK
if [ "$opt_build" -ne 0 ]; then
    abort()
    {
        echo ""
        echo -e "${bldred}An error occurred. Bad apk name ($REPLAY). Exiting...${rst}"
        echo ""
        exit 1
    }
    trap 'abort' 0
    set -e
    . build/envsetup.sh
    lunch "emotion_$device-userdebug"
    echo -e "${bldcya}What application do you want compile?${rst}"
    read REPLAY
    make "$REPLAY"
    trap : 0
    echo -e "${bldcya}Done,$REPLAY compiled${rst}"
    echo ""
    exit 1
fi

# Disable ADB authentication
if [ "$opt_adb" -ne 0 ]; then
    echo -e "${bldcya}Disabling ADB authentication and setting root access to Apps and ADB${rst}"
    export DISABLE_ADB_AUTH=true
    echo ""
else
    unset DISABLE_ADB_AUTH
fi


# Lower RAM devices
if [ "$opt_lrd" -ne 0 ]; then
    echo -e "${bldcya}Applying optimizations for devices with low RAM${rst}"
    export EMOTION_LOW_RAM_DEVICE=true
    echo ""
else
    unset EMOTION_LOW_RAM_DEVICE
fi


# Reset source tree
if [ "$opt_reset" -ne 0 ]; then
    echo -e "${bldcya}Resetting source tree and removing all uncommitted changes${rst}"
    repo forall -c "git reset --hard HEAD; git clean -qf"
    echo ""
fi


# Repo sync/snapshot
if [ "$opt_sync" -eq 0 ]; then
    # Sync with latest sources
    echo -e "${bldcya}Force sync latest sources${rst}"
    repo sync -c -f -qj"$opt_jobs" --force-sync --no-clone-bundle
    echo ""
elif [ "$opt_sync" -eq 1 ]; then
    # Sync with latest sources
    echo -e "${bldcya}Fetching latest sources${rst}"
    repo sync -qj"$opt_jobs"
    echo ""
elif [ "$opt_sync" -eq 2 ]; then
    # Take snapshot of current sources
    echo -e "${bldcya}Making a snapshot of the repo${rst}"
    repo manifest -o snapshot-"$device".xml -r
    echo ""
elif [ "$opt_sync" -eq 3 ]; then
    # Restore snapshot tree, then sync with latest sources
    echo -e "${bldcya}Restoring last snapshot of sources${rst}"
    echo ""
    cp snapshot-"$device".xml .repo/manifests/

    # Prevent duplicate projects
    cd .repo/local_manifests
    for file in *.xml; do
        mv "$file" "$(echo $file | sed 's/\(.*\.\)xml/\1xmlback/')"
    done

    # Start snapshot file
    cd "$DIR"
    repo init -m snapshot-"$device".xml
    echo -e "${bldcya}Fetching snapshot sources${rst}"
    echo ""
    repo sync -qdj"$opt_jobs"

    # Prevent duplicate backups
    cd .repo/local_manifests
    for file in *.xmlback; do
        mv "$file" "$(echo $file | sed 's/\(.*\.\)xmlback/\1xml/')"
    done

    # Remove snapshot file
    cd "$DIR"
    rm -f .repo/manifests/snapshot-"$device".xml
    repo init
fi


# Setup environment
echo -e "${bldcya}Setting up environment${rst}"
echo -e "${bldmag}${line}${rst}"
. build/envsetup.sh
echo -e "${bldmag}${line}${rst}"


# This will create a new build.prop with updated build time and date
rm -f "$OUTDIR"/target/product/"$device"/system/build.prop

# This will create a new .version for kernel version is maintained on one
rm -f "$OUTDIR"/target/product/"$device"/obj/KERNEL_OBJ/.version


# Lunch device
echo ""
echo -e "${bldcya}Lunching device${rst}"
lunch "emotion_$device-userdebug"


# Get extra options for build
if [ "$opt_extra" -eq 1 ]; then
    opt_v=" "showcommands
elif [ "$opt_extra" -eq 2 ]; then
    opt_v=" "-s
else
    opt_v=""
fi


# Ignore minor errors during build
if [ "$opt_ignore" -eq 1 ]; then
    opt_i=" "-k
    export TARGET_IGNORE_ERRORS=true
    echo -e "true" > .ignore_err
    if [ "$opt_log" -eq 0 ]; then
        opt_log=1
    fi
else
    opt_i=""
fi


# Log file options
if [ "$opt_log" -ne 0 ]; then
    rm -rf build.log
    if [ "$opt_log" -eq 1 ]; then
        exec 2> >(sed -r 's/'$(echo -e "\033")'\[[0-9]{1,2}(;([0-9]{1,2})?)?[mK]//g' | tee -a build.log)
    else
        exec &> >(tee -a build.log)
    fi
fi


# Start compilation
if [ "$opt_only" -eq 1 ]; then
    echo -e "${bldcya}Starting compilation: ${bldgrn}Building Boot Image only${rst}"
    echo ""
    make -j$opt_jobs$opt_v$opt_i bootzip
else
    if [ -z "$EMOTION_VERSION_MINOR" ]; then
        echo -e "${bldcya}Starting compilation: ${bldgrn}Building ${bldylw}EMOTION-ROM ${bldmag}$EMOTION_VERSION_MAJOR ${bldred}$EMOTION_MAINTENANCE${rst}"
    else
        echo -e "${bldcya}Starting compilation: ${bldgrn}Building ${bldylw}EMOTION-ROM ${bldmag}$EMOTION_VERSION_MAJOR ${bldcya}$EMOTION_VERSION_MINOR ${bldred}$EMOTION_MAINTENANCE${rst}"
    fi
    echo ""
    make -j$opt_jobs$opt_v$opt_i bacon
fi

# Cleanup unused built
rm -f "$OUTDIR"/target/product/"$device"/cm-*.*
rm -f "$OUTDIR"/target/product/"$device"/emotion_*-ota*.zip
