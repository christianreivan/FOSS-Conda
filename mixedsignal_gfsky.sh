#!/bin/sh

enterdir() {
cd $1/$2/
}

first() {
if [ -d "$HOME/.klayout/" ]
then
	rm -rf "$HOME/.klayout/"
elif [ -d "$HOME/.xschem/" ]
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
	enterdir $HOME $caddir
	while [ -f "$HOME/$caddir/silicon-installer${i}.sh" ]
	do
		echo "File \"$HOME/$caddir/silicon-installer${i}.sh\" already exists!"
		echo -n "Do you want to remove the existing installer file [y/n]? :  "
		read ans
		if [ "$ans" == "y" || "$ans" == "Y" ]
		then
			rm -f "$HOME/$caddir/silicon-installer${i}.sh"
		fi
		((i+=1))
	done
	
	#Update the repo URL with the latest release on https://github.com/proppy/conda-eda/releases
	curl -L -o $HOME/$caddir/silicon-installer${i}.sh https://github.com/proppy/conda-eda/releases/download/v0.0-1452-g75fd8b9/mixed-signal-0-Linux-x86_64.sh
	
	while [ -d "$HOME/mixed-signal.gfsky_${j}/" ]
	do
		echo "Directory \"$HOME/mixed-signal.gfsky_${j}/\" already exists!"
		echo -n "Do you want to remove the existing installer directory [y/n]? :  "
		read ans
		if [ "$ans" == "y" || "$ans" == "Y" ]
		then
			rm -rf "$HOME/mixed-signal.gfsky_${j}/"
		fi
		((j+=1))
	done
	
	bash $HOME/$caddir/silicon-installer${i}.sh -b -p $HOME/mixed-signal.gfsky_${j}/
	source $HOME/mixed-signal.gfsky_${j}/bin/activate
}
###################################################################################################
cd ~
i=0
j=0
HOME=$PWD
caddir="Downloads" #change the folder name as you like

#First thing to do. I'm not sure whether this can be omitted or not. You can try to experiment with it :)
first

#Process...
if [ ! -d "$HOME/$caddir/" ];
then
	mkdir -p $caddir
	setup
	echo "Finished executing..."
	echo
	xschem -v
	ngspice -v
	klayout -v
	codegen_main --version # xls
	yosys --version
	sby --help
	iverilog -V
	openroad -version
	netgen -batch quit
	magic -dnull -noconsole --version
	echo exit | flow.tcl -interactive # openlane
	echo $PDK_ROOT
	echo $PDK
	exit 1
else
	setup
	echo "Finished executing..."
	echo
	xschem -v
	ngspice -v
	klayout -v
	codegen_main --version # xls
	yosys --version
	sby --help
	iverilog -V
	openroad -version
	netgen -batch quit
	magic -dnull -noconsole --version
	echo exit | flow.tcl -interactive # openlane
	echo $PDK_ROOT
	echo $PDK
	exit 1
fi

