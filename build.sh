#!/bin/bash
# Build openwrt

# Stop on error
set -e

#commands
COMMAND='$1'
ADDITIONAL='$2'
#Path
TOP=${PWD}

# Colors
YELLOW='\033[33m'
NC='\033[0m'
txtrst='\e[0m'  # Color off
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtblu='\e[0;34m' # Blue



# Enviroment
echo -e "$YELLOW--> Setting up enviroment... $NC"
GIT_URL='https://git.openwrt.org/openwrt/openwrt.git'
GIT_BRANCH='v19.07.0-rc1'
RESET_GIT='false'
CORES=`cat /proc/cpuinfo | grep processor | wc -l`
EXTRA_OPTIONS='true'
DEBUG='true'
CONFIG=''

# Setup ccache and update symlinks
sudo /usr/sbin/update-ccache-symlinks
export PATH="/usr/lib/ccache:$PATH"
echo -e "$txtgrn-->  Argument: $1"

# Git clone openwrt openwrt
echo -e "$txtgrn--> Checking for source files... $NC"
if [ ! -d openwrt/ ]
    then
        echo -e "No source files found"
        echo -e "$YELLOW--> Starting git clone for $GIT_URL $NC"
        git clone $GIT_URL -b $GIT_BRANCH
        cd openwrt

        ./scripts/feeds update -a
        ./scripts/feeds install -a
    else
        echo -e "$txtgrn --> Found existing source files"
        echo -e "$txtgrn --> Updating source files"

        cd openwrt
        rm -rf feeds/*
        rm -rf package/*

        if [ $RESET_GIT = true ]
            then
                echo -e "$YELLOW--> Resetting git... $NC"
                git fetch origin
                git reset --hard origin/$GIT_BRANCH
                git clean -f -d
                git pull
                make dirclean
            else
                echo -e "$YELLOW--> Cleaning up source... $NC"
                make distclean
        fi
        ./scripts/feeds update -a
        ./scripts/feeds install -a
fi

# Setup .config from config.seed and update seed for new changes
	echo -e "$txtred--> Setup source for compile... $NC"  
	cp ../config.seed ../openwrt/.config
	make defconfig

if [$1 = 'buildconfig']
then
	echo -e "$txtblu--> Custom setup for compile... $NC"  
	make menuconfig
	cp ../config.seed ../openwrt/.config
	make defconfig
else
	echo -e "$txtred--> config not customize.. $NC"  

fi
# Prepare for multicore compile
echo -e "$YELLOW--> Prepare for multicore compile... $NC"
make download
# Make output folders
echo -e "$YELLOW--> Starting compile... $NC"
mkdir -p ../output

# Check for debug and compile
if [ $DEBUG = true ]
    then
        echo -e "Running with debug enabled"
        rm -rf ../output/make.log
        time ionice -c 3 nice -n 20 make -j1 V=s 2>&1 | tee ../output/make.log | grep -i error
    else
        time ionice -c 3 nice -n19 make -j$CORES
fi

# Copying to output folder
echo -e "$txtgrn--> Copying files to output folder... $NC"
mkdir -p ../output/$(date +%Y%m%d%H%M)

if [ -s "../output/make.log" ]
    then
        mv ../output/make.log ../output/$(date +%Y%m%d%H%M)/make.log
fi

cp -R bin/targets/* ../output/$(date +%Y%m%d%H%M)/

exit 0

