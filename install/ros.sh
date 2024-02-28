#!/bin/bash
set -e
set -x

ROS_VERSION="humble"

sudo curl -y 1 -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	ros-${ROS_VERSION}-desktop \
	ros-${ROS_VERSION}-cyclonedds \
	ros-${ROS_VERSION}-rmw-cyclonedds-cpp \
	ros-${ROS_VERSION}-gps-msgs \
	ros-${ROS_VERSION}-vision-msgs \
	ros-${ROS_VERSION}-bondcpp \
	ros-${ROS_VERSION}-test-msgs \
	ros-${ROS_VERSION}-behaviortree-cpp-v3 \
	ros-${ROS_VERSION}-diagnostic-updater \
	ros-${ROS_VERSION}-ompl \
	ros-${ROS_VERSION}-gazebo-ros-pkgs \
	python3-rosdep \
	python3-colcon-common-extensions \
	libgflags-dev \
	xtensor-dev \
	libceres-dev \
	gz-garden \
	graphicsmagick-libmagick-dev-compat

sudo apt install ros-humble-actuator-msgs 
