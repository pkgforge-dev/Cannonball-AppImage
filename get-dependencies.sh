#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost       \
    cmake       \
    libdecor    \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building Cannonball..."
echo "---------------------------------------------------------------"
REPO="https://github.com/djyt/cannonball"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./cannonball
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin/res
mkdir -p ./AppDir/bin/roms
cd ./cannonball
patch -p1 -N -r - -i ../no-force-alsa.patch
cmake -S ./cmake -B build -D CMAKE_BUILD_TYPE=Release -DTARGET=linux.cmake -DOpenGL_GL_PREFERENCE=GLVND -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build -j$(nproc)
mv -v build/cannonball ../AppDir/bin
mv -v ./res/config.xml ../AppDir/bin
sed -i s/hires\>0/hires\>1/g ../AppDir/bin/config.xml
mv -v ./res/tilemap.bin ./res/tilepatch.bin  ../AppDir/bin/res
cd ..
git clone https://github.com/jacktang/outrun-roms
mv -v ./outrun-roms/* -t ./AppDir/bin/roms
