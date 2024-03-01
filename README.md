# px4-gz-docker

Additional backup trial maze world is located in the /work/models/maze_sample directory
Please build ros_gz from source. [see ros-gz](https://github.com/gazebosim/ros_gz)

## Download Src Files

```bash
./get_src.sh
```

## Build and run

To build the image

```bash
docker compose build
```

If there is no gpu on your pc, you have to comment the docker-compose.override.yml file

Run the container

```bash
./run_dev.sh
```

To access the shell of the container, this will open 2 new terminal windows

```bash
docker exec -u user -it px4_gz-px4_gz-1 terminator & docker exec -u user -it px4_gz-px4_gz-1 terminator
```

## Running Gazebo

Divide one of the terminal windows in two and run the following commands in the two panes:

1.
   - `cd px4 && make px4_sitl` to build px4_sitl first. (This only need to be built once in one of the container shells)
   - `PX4_SYS_AUTOSTART=4001 PX4_GZ_MODEL=x500_lidar PX4_GZ_WORLD=maze_sample ./build/px4_sitl_default/bin/px4 -i 1` to start px4_sitl instance 1 with x500 with added lidar plugin in gz-garden on a sample maze model. (PX4_GZ_MODEL=x500 to run base x500 model)
2. `MicroXRCEAgent udp4 -p 8888` to start DDS agent for communication with ROS2

## Running PX4-offboard

- `cd ros2_ws` to
- `rosdep install -y -r -q --from-paths src --ignore-src --rosdistro humble` to download dependencies
- `colcon build` to build ros2 workspace
- `source install/setup.bash` to source the ros2 environment (this will be done automatically for the next bash sessions)
- From the built repository under px4_offboard, to run the offboard script, run `ros2 run px4_offboard [script name]` to communicate between the gazebo and ros2 envrionment and use offboard controls with px4.

## Examples

1. dsd
   - `gz sim visualize_lidar.sdf`
   - `ros2 run ros_gz_bridge parameter_bridge /lidar@sensor_msgs/msg/LaserScan[ignition.msgs.LaserScan --ros-args -r /lidar:=/laser_scan`
   - `ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map model_with_lidar/link/gpu_lidar`
   - `rviz2`
2.
   - `make px4_sitl gz_x500`
   - `MicroXRCEAgent udp4 -p 8888`
   - `ros2 run px4_ros_com offboard_control`

## Environment Variables

- `PX4_GZ_MODEL` Name of the px4 vehicle model to spawn in gz
- `PX4_GZ_MODEL_POSE` Spawn pose of the vehicle model, must used with `PX4_GZ_MODEL`
- `PX4_MICRODDS_NS` Namespace assigned to the sitl vehicle, normally associated with px4 instances, but can be set mannually
- `ROS_DOMAIN_ID` Separate each container into its own domain (Is it still necessary since each SITL instance has a unique namespace?)
  
## Drivers and Supporting Software

Tested versions:

- Ros: `Rolling` and `Humble`
- Gazebo: `Garden`
- Docker: `24.0.7`

### Install Docker CLI

- Install Docker CLI using the instructions on the [Docker Installation Page](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
- Note: Docker Desktop may interfere with Nvidia Drivers.

### Nvidia Drivers

- Automatically install recommended drivers:

  ```bash
  sudo ubuntu-drivers autoinstall
  ```

- Manually install recommended drivers:
  `ubuntu-drivers devices` To list recommended drivers

  ```bash
    sudo apt install nvidia-driver-<version>
    ```

- Nvidia Container Toolkit
    if encountering a ‘nvidia-container-cli’ initialization error, refer to the [Nvidia Container Toolkit Installation Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

### Debugging

- If encountering an error related to “actuator_msgs” during docker build:
  - Include [actuator_msg](https://github.com/rudislabs/actuator_msgs) package from source

## Resources

- PX4 with ROS-Gazebo simulation overview: [PX4 Dev Guide](https://dev.px4.io/master/en/simulation/ros_interface.html)
- Previous Spring 2022 IEEE Autonomous UAV "Drone" Chase Challenge - [Video](https://www.youtube.com/watch?v=uISFK83FSmQ&ab_channel=JamesGoppert)
- Issues Tracking: [Github Issues]

## Note

### Changelog

- Aggiunta di pacchetti necessari per ros2
- Rimozione di navigation2 da `run_dev.sh`, potrebbe servire, in tal caso si può provare a installarlo da apt

### Cose

- Non funzione il takeoff nel loro mondo

### Cose utili

- `rosdep check --from-paths . --ignore-src --rosdistro humble`
- `rosdep install -y -r -q --from-paths src --ignore-src --rosdistro humble`
- `ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map model_with_lidar/link/gpu_lidar` per il lidar
- ign è diverso da gz, ign è vecchio
