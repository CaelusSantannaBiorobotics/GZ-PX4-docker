#!/bin/bash
set -e
set -x

sudo rosdep init
rosdep update

cat << EOF >> ~/.bashrc
echo sourcing ~/.bashrc
source /opt/ros/humble/setup.bash
export CCACHE_TEMPDIR=/tmp/ccache
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export PYTHONWARNINGS=ignore:::setuptools.installer,ignore:::setuptools.command.install
export GZ_VERSION=garden
if [ -f ~/work/gazebo/install/setup.sh ]; then
  source ~/work/gazebo/install/setup.sh
  echo "gazebo built, sourcing"
fi
if [ -f ~/work/ros2_ws/install/setup.sh ]; then
  source ~/work/ros2_ws/install/setup.sh
  echo "workspace built, sourcing"
fi
if [ -f ~/work/maze_ros2_ws/install/setup.sh ]; then
  source ~/work/maze_ros2_ws/install/setup.sh
  echo "maze-workspace built, sourcing"
fi
source /usr/share/colcon_cd/function/colcon_cd.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

PROMPT_COMMAND='history -a'
HISTTIMEFORMAT="%F %T "

# export GZ_SIM_RESOURCE_PATH=~/work/gz_maps/worlds/:~/work/gz_maps/models/
export GZ_SIM_RESOURCE_PATH=~/work/maze_ros2_ws/src/px4_vision_description/gz_maps/worlds:~/work/maze_ros2_ws/src/px4_vision_description/gz_maps/models
#ulimit -n 1024
EOF
