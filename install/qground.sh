#!/bin/bash
set -e
set -x

sudo usermod -a -G dialout user
sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get remove modemmanager -y
sudo DEBIAN_FRONTEND=noninteractive apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
sudo DEBIAN_FRONTEND=noninteractive apt install libfuse2 -y
sudo DEBIAN_FRONTEND=noninteractive apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 -y

