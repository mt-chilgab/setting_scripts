#!/bin/bash

pwd_=$PWD

echo "Detecting OpenFOAM installation..."
[ ! -eq 

echo "Setting OpenFOAM env vars..."
source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc WM_NCOMPPROCS=4 WM_MPLIB=SYSTEMOPENMPI

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
