#!/bin/bash

pwd_=$PWD
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)


echo "Installing dependencies..."
sudo apt-get update
sudo apt-get -y install build-essential cmake flex bison zlib1g-dev qt4-dev-tools libqt4-dev libqtwebkit-dev gnuplot libreadline-dev libncurses5-dev libxt-dev libopenmpi-dev openmpi-bin libboost-system-dev libboost-thread-dev libgmp-dev libmpfr-dev python python-dev libcgal-dev libglu1-mesa-dev libqt4-opengl-dev

echo "Setting DISPLAY variable and setting LIBGL_ALWAYS_INDIRECT to 1"
if ! grep -q "export\sDISPLAY" ~/.bashrc; then
	echo "# sets DISPLAY variable for X window operations" >> ~/.bashrc
	echo "export DISPLAY=\$(grep -m 1 nameserver /etc/resolv.conf | awk '{print \$2}'):0" >> ~/.bashrc
else
	echo "DISPLAY var exists!"
fi

if ! grep -q "export\sLIBGL_ALWAYS_INDIRECT" ~/.bashrc; then
	echo "# sets LIBGL_ALWAYS_INDIRECT to 1" >> ~/.bashrc
	echo "export LIBGL_ALWAYS_INDIRECT=1" >> ~/.bashrc
else
	echo "LIBGL_ALWAYS_INDIRECT is already set!"
fi

echo "Adding Salome and Helyx-OS to PATH..."
if ! grep -q "export\sPATH.*salome.*HELYX-OS" ~/.bashrc; then
	echo "# adds Salome and Helyx-OS to PATH" >> ~/.bashrc
	echo "export PATH=\$PATH:/opt/salome/appli_V7_4_0:/opt/Engys/HELYX-OS/v2.3.1" >> ~/.bashrc
else
	echo "Already exists in PATH!"
fi

echo "Adding alias setof231 to .bashrc..."
if ! grep -q "alias\ssetof231" ~/.bashrc; then
	echo "# alias for OpenFOAM v2.3.1 setup" >> ~/.bashrc
	echo "alias setof231=\"chmod a+x $script_dir/setof.sh && source $script_dir/setof.sh\"" >> ~/.bashrc
else
	echo "Alias already exists!"
fi

echo "Adding alias of231 to .bashrc..."
if ! grep -q "alias\sof231" ~/.bashrc; then
	echo "# alias for OpenFOAM v2.3.1 variables setup" >> ~/.bashrc
	echo "alias of231=\"source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc \$FOAM_SETTINGS\"" >> ~/.bashrc
else
	echo "Alias already exists!"
fi

source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc $FOAM_SETTINGS

echo "Making FOAM_RUN and extension directory if they don't exist..." 
[ ! -d "$FOAM_RUN/../OpenFOAM_extensions" ] && mkdir -p $FOAM_RUN/../OpenFOAM_extensions
cd $FOAM_RUN/../OpenFOAM_extensions

echo "Cloning and installing vim extension for OpenFOAM from GIT..."
if [ ! -d "$FOAM_RUN/../OpenFOAM_extensions/vimExtensionOpenFOAM" ]; then
	git clone https://shor-ty@bitbucket.org/shor-ty/vimExtensionOpenFOAM.git >> /dev/null
	cd vimExtensionOpenFOAM
	chmod a+x ./install
	./install
else
	echo "Already installed!"
fi

echo "Finished"
cd $pwd_
