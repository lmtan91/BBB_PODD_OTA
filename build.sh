#!/bin/bash

#
# build script
#

USAGE=$"usage: build.sh ( -setup ) 
"
BRANCH="dunfell"
TOP_DIR=`pwd`
POKY_DIR=$TOP_DIR/poky-$1
BBB_DIR=$TOP_DIR/bbb

echo $TOP_DIR

set -o pipefail
set -e

# $1: folder to clone source
# $2: meta-xxx
# $3: branch
clone_source() 
{
    if [ ! -d $1 ]; then
	if [ "$1" = "$POKY_DIR" ]; then
            git clone -b dunfell git://git.yoctoproject.org/poky.git $POKY_DIR
	else
	    mkdir -p $1
	fi
    fi

    cd $1

    if [ ! -d $2 ]; then
	if [ "$2" = "meta-openembedded" ]; then
    	    git clone -b $3 git://git.openembedded.org/meta-openembedded
	elif [ "$2" = "meta-qt5" ]; then
    	    git clone -b $3 https://github.com/meta-qt5/meta-qt5.git
	elif [ "$2" = "meta-security" ]; then
    	    git clone -b $3 git://git.yoctoproject.org/meta-security.git
	elif [ "$2" = "meta-jumpnow" ]; then
    	    git clone -b $3 https://github.com/jumpnow/meta-jumpnow.git
	elif [ "$2" = "meta-bbb" ]; then
    	    git clone -b $3 https://github.com/lmtan91/meta-bbb.git
	fi
	return
    fi

    cd $2

    currbranch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

    if [ $currbranch != "$3" ]; then
        echo "Info: $currbranch neq $3 for $2" 
        git checkout $3
    fi
}

################################################################################
# start main build
################################################################################

clone_source $POKY_DIR meta-openembedded dunfell
clone_source $POKY_DIR meta-qt5 dunfell
clone_source $POKY_DIR meta-security dunfell
clone_source $POKY_DIR meta-jumpnow dunfell

# Create BBB folder
mkdir -p $BBB_DIR

clone_source $BBB_DIR meta-bbb dunfell

### Initialize the build directory
cd $TOP_DIR
source $POKY_DIR/oe-init-build-env $BBB_DIR/build

cp $BBB_DIR/meta-bbb/conf/local.conf.sample $BBB_DIR/build/conf/local.conf
cp $BBB_DIR/meta-bbb/conf/bblayers.conf.sample $BBB_DIR/build/conf/bblayers.conf

sed -i "s@\${HOME}@$TOP_DIR@g" $BBB_DIR/build/conf/bblayers.conf

bitbake poddota-image
