#!/bin/sh

enterdir() {
cd $1/$2/
}

first() {
if [ -d "$HOME/.klayout/" ]
then
	rm -rf "$HOME/.klayout/"
elif [ "$HOME/.xschem/" ]
then
	rm -rf "$HOME/.xschem/"
elif [ -f "$HOME/.magic_tkcon_hst" ]
then
	rm -f "$HOME/.magic_tkcon_hst"
elif [ -f "$HOME/.netgen_tkcon_hst" ]
then
	rm -f "$HOME/.netgen_tkcon_hst"
fi
}

setup() {
	mkdir -p $caddir
	enterdir $HOME $caddir
	curl -L -o $HOME/$caddir/silicon-installer.sh https://github.com/proppy/conda-eda/releases/download/v0.0-1440-g8d08c27/mixed-signal-0-Linux-x86_64.sh
	if [ -d "$HOME/mixed-signal.sky130a/" ]
	then
		rm -rf $HOME/mixed-signal.sky130a/
	fi
	bash $HOME/$caddir/silicon-installer.sh -p $HOME/mixed-signal.sky130a/
	source $HOME/mixed-signal.sky130a/bin/activate
}
###################################################################################################
cd ~
HOME=$PWD
caddir="cads" #change the folder name as you like

#First thing to do...
first
#Process...
if [ ! -d "$HOME/$caddir/" ];
then
	setup
	echo "Finished executing..."
	exit 1
else
	echo "$caddir exists"
	echo -n "Do you still want to continue the process [y/n]? :  "
	read ans
	if [ "$ans" == "y" ] || [ "$ans" == "Y" ]
	then
		rm -rf $HOME/$caddir/
		setup
	else
		echo "Finished executing..."
		exit 0
	fi
fi

