#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q cannonball-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/cannonball.png
export DESKTOP=/usr/share/applications/cannonball.desktop
export STARTUPWMCLASS=cannonball
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /opt/cannonball
mkdir -p ./AppDir/bin
mv -v /opt/cannonball/res ./AppDir/bin
mv -v /opt/cannonball/config.xml ./AppDir/bin
wget -O ./AppDir/bin/res/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
