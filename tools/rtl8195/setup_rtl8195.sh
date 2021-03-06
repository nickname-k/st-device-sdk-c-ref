#!/bin/bash

CHIP_NAME=${1}

if [ -L bsp/${CHIP_NAME}/component/common/iot-core ]; then
    rm bsp/${CHIP_NAME}/component/common/iot-core
fi

ln -s ../../../../iot-core bsp/${CHIP_NAME}/component/common/iot-core

git submodule status bsp/${CHIP_NAME} &> /dev/null
if [ "$?" == "0" ]; then
	cd bsp/${CHIP_NAME}
	git am ../../patches/${CHIP_NAME}/*.patch
else
	if [ "$(ls bsp/${CHIP_NAME})" == "" ]; then
		echo "Failed to find source code in bsp/${CHIP_NAME}"
	else
		cd bsp/${CHIP_NAME}
		for patch in ../../patches/${CHIP_NAME}/*
			do patch -f -p1 < ${patch}
		done
	fi  
	echo "Check source code in bsp/${CHIP_NAME}"
fi

