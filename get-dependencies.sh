#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost       \
    cmake       \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Cannonball..."
echo "---------------------------------------------------------------"
REPO="https://github.com/djyt/cannonball"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./cannonball
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin/res
mkdir -p ./AppDir/bin/roms
cd ./cannonball
patch -p1 -N -r - -i ../no-force-alsa.patch
cmake -S ./cmake -B build -DCMAKE_BUILD_TYPE=Release -DTARGET=linux.cmake -DOpenGL_GL_PREFERENCE=GLVND -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build -j$(nproc)
mv -v build/cannonball ../AppDir/bin
mv -v ./res/config.xml ../AppDir/bin
sed -i s/hires\>0/hires\>1/g ../AppDir/bin/config.xml
mv -v ./res/tilemap.bin ./res/tilepatch.bin  ../AppDir/bin/res
