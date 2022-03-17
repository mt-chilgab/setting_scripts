#!/bin/bash

pwd_=$PWD

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get -y install build-essential cmake flex bison zlib1g-dev qt4-dev-tools libqt4-dev libqtwebkit-dev gnuplot libreadline-dev libncurses5-dev libxt-dev libopenmpi-dev openmpi-bin libboost-system-dev libboost-thread-dev libgmp-dev libmpfr-dev python python-dev libcgal-dev libglu1-mesa-dev libqt4-opengl-dev

echo "Setting DISPLAY variable and setting LIBGL_ALWAYS_INDIRECT to 1"
export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

echo "Adding alias of231 to .bashrc..."
if [[ $(cat ~/.bashrc | grep -oP "of231") == "of231" ]]; then
	echo "Alias exists!"
else
	echo "alias of231=\"chmod a+x $(pwd -P)/setof.sh && source $(pwd -P)/setof.sh\"" >> ~/.bashrc
fi

echo "Setting OpenFOAM env vars..."
source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc $FOAM_SETTINGS

echo "Making FOAM_RUN and extension directory if they don't exist..." 
[ ! -d "$FOAM_RUN/../OpenFOAM_extensions" ] && mkdir -p $FOAM_RUN/../OpenFOAM_extensions
cd $FOAM_RUN/../OpenFOAM_extensions

echo "Cloning and installing vim extension for OpenFOAM from GIT..."
git clone https://shor-ty@bitbucket.org/shor-ty/vimExtensionOpenFOAM.git > /dev/null
cd vimExtensionOpenFOAM
chmod a+x ./install
./install

echo "Finished"
cd $pwd_
