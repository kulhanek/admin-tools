#!/bin/bash

SITES="our-clusters"
PKG="admin-tools"
MAJOR_VERSION=2
PREFIX="common"

set -o pipefail

# ------------------------------------

if [ -z "$AMS_ROOT" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

# ------------------------------------
module add cmake

# names ------------------------------
GITREVS=`git rev-list --count HEAD`
GITHASH=`git rev-parse --short HEAD`
NAME="admin-tools"
VERSION="$MAJOR_VERSION.$GITREVS.$GITHASH"
ARCH="noarch"
echo "Build: $PKG:$VERSION:$ARCH:single"

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX=$SOFTREPO/$PREFIX/$PKG/$VERSION/$ARCH/single .
make install
if [ $? -ne 0 ]; then exit 1; fi

cd ..

# prepare build file -----------------
SOFTBLDS=$AMS_ROOT/etc/map/builds/$PREFIX
VERIDX=`ams-map-manip newverindex ${PKG}`

cat > $SOFTBLDS/$PKG:$VERSION:$ARCH:single.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="admin-tools" ver="$VERSION" arch="$ARCH" mode="single" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/admin-tools/$VERSION/$ARCH/single" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/admin-tools/$VERSION/$ARCH/single/bin" operation="prepend"/>
    </setup>
</build>
EOF
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Adding builds ..."
ams-map-manip addbuilds $SITES $PKG:$VERSION:$ARCH:single >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Distribute builds ..."
ams-map-manip distribute >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Rebuilding cache ..."
ams-cache rebuildall >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Log file: ams.log"
echo ""

