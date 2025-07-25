#!/bin/bash
####################################################

# Define the hardware type
# Note: Must match the axi-soc-ultra-plus-core/hardware directory name
hwType=XilinxZcu102

# Define number of DMA lanes
numLane=2

# Define number of DEST per DMA lane
numDest=1

# Define number of DMA TX/RX Buffers
rxBuffCnt=128
txBuffCnt=128

# Define DMA Buffer Size
buffSize=0x80000 # 512kB

####################################################

if [ $# -ne 1 ]
then
   echo "Usage: BuildYoctoProject.sh xsa"
   return 1
fi

# Define the target name
xsaPath=$(realpath "${1}")

# Define the target name
targetName=${PWD##*/}

# Define the base dir
basePath=$(realpath "$PWD/../..")

# Make the build output
mkdir -p $basePath/build
mkdir -p $basePath/build/YoctoProjects
buildPath=$basePath/build/YoctoProjects

# Execute the common build Yocto project script
../../submodules/axi-soc-ultra-plus-core/BuildYoctoProject.sh \
-p $buildPath -n $targetName -x $xsaPath -h $hwType \
-l $numLane -d $numDest -t $txBuffCnt -r $rxBuffCnt -s $buffSize
