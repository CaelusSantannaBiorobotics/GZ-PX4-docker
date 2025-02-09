#!/bin/bash
if [ ! -d ./work/px4 ] ; then
    cd ./work
    git clone git@github.com:CaelusSantannaBiorobotics/PX4-Autopilot.git -b caelus-maze px4
    cd px4
    git tag v1.14.0-beta2
    cd ../..
fi

if [ ! -d ./work/ros2_ws/src ] ; then
    mkdir -p ./work/ros2_ws/src
    cd work/ros2_ws/src
    git clone git@github.com:PX4/px4_msgs.git
    git clone git@github.com:w-sribunma/px4-offboard.git
    # git clone -b humble git@github.com:gazebosim/ros_gz.git
    # git clone https://github.com/ros-planning/navigation2.git --branch humble # se lo vuoi usare cancella la cartella system test
    cd ../../..
fi

# If no file named QgroundControl.AppImage exists, download it
if [ ! -f ./work/QGroundControl.AppImage ] ; then
    cd  ./work
    wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
    chmod +x QGroundControl.AppImage
fi