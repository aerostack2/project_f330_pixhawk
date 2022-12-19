#!/bin/bash

# Install dependencies

PX4_FOLDER="$AEROSTACK2_WORKSPACE/src/thirdparty/PX4-Autopilot"

mkdir -p $AEROSTACK2_WORKSPACE/src/thirdparty
cd $AEROSTACK2_WORKSPACE/src/thirdparty

git clone --recurse-submodules -j$(nproc) https://github.com/aerostack2-developers/PX4-Autopilot.git && \
    cp $AEROSTACK2_PATH/thirdparty/px4_required_packages/px4_configs/urtps_bridge_topics.yaml $PX4_FOLDER/msg/tools/ && \
    cp $AEROSTACK2_PATH/thirdparty/px4_required_packages/px4_configs/px4-rc.params $PX4_FOLDER/ROMFS/px4fmu_common/init.d-posix/ && \
    bash $PX4_FOLDER/Tools/setup/ubuntu.sh

