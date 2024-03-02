# px4-gz-docker

All the px4 models are stored in `work/gz_maps`

```txt
work/
┣ px4/                  Cartella del px4
┣ ros2_ws/              Cartella con dipendenze di ros
┃ ┗ src/
┃   ┣ px4_msgs/
┃   ┣ px4-offboard/
┣ maze_ros2_ws/         Nostra repo di ros
┗ .gitignore
```

## Download Src Files

```bash
./get_src.sh
```

## Build and run

To build the image

```bash
docker compose build
```

If there is no gpu on your pc, you have to comment the docker-compose.override.yml file.

## Run

Run the container

```bash
./run_dev.sh
```

To access the shell of the container, this will open 2 new terminal windows

```bash
docker exec -u user -it px4_gz-px4_gz-1 terminator & \
docker exec -u user -it px4_gz-px4_gz-1 terminator
```

## Running PX4 + Gazebo

Divide one of the terminal windows in two and run the following commands in the two panes:

1.
   - `cd px4 && make px4_sitl` to build px4_sitl first. (This only need to be built once in one of the container shells)
   - `PX4_SYS_AUTOSTART=4001 PX4_GZ_MODEL=x500_lidar PX4_GZ_WORLD=maze_sample ./build/px4_sitl_default/bin/px4 -i 0` to start px4_sitl instance 0 with x500 with added lidar plugin in gz-garden on a sample maze model.
     - Se si vogliono usare più modelli, invece di `-i 0` mettere `-i 1`, `-i 2` etc., i topic sono nella forma:
       - `-i 0`: `/fmu/out/vehicle_control_mode`
       - `-i 1`: `/px4_1/fmu/out/vehicle_control_mode`
       - `-i 2`: `/px4_2/fmu/out/vehicle_control_mode`
1. `MicroXRCEAgent udp4 -p 8888` to start DDS agent for communication with ROS2

## Running PX4-offboard

- `cd ros2_ws` to
- `rosdep install -y -r -q --from-paths src --ignore-src --rosdistro humble` to download dependencies
- `colcon build` to build ros2 workspace
- `source install/setup.bash` to source the ros2 environment (this will be done automatically for the next bash sessions)
- From the built repository under px4_offboard, to run the offboard script, run `ros2 run px4_offboard [script name]` to communicate between the gazebo and ros2 envrionment and use offboard controls with px4.

## Examples

1. Lidar in gazebo + rviz2
   - `gz sim visualize_lidar.sdf`
   - `ros2 run ros_gz_bridge parameter_bridge /lidar@sensor_msgs/msg/LaserScan[ignition.msgs.LaserScan --ros-args -r /lidar:=/laser_scan`
   - `ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map model_with_lidar/link/gpu_lidar`
   - `rviz2`
2. Offboard from ros2
   - `make px4_sitl gz_x500`
   - `MicroXRCEAgent udp4 -p 8888`
   - `ros2 run px4_ros_com offboard_control`

## Environment Variables

- `PX4_GZ_MODEL` Name of the px4 vehicle model to spawn in gz
- `PX4_GZ_MODEL_POSE` Spawn pose of the vehicle model, must be used with `PX4_GZ_MODEL`
- `PX4_MICRODDS_NS` Namespace assigned to the sitl vehicle, normally associated with px4 instances, but can be set mannually
- `ROS_DOMAIN_ID` Separate each container into its own domain (Is it still necessary since each SITL instance has a unique namespace?)
  
## Drivers and Supporting Software

Tested versions:

- Ros: `Rolling` and `Humble`
- Gazebo: `Garden`
- Docker: `24.0.7`

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

- Rimozione di navigation2 da `run_dev.sh`, potrebbe servire, in tal caso si può provare a installarlo da apt

### Cose

- Non funzione il takeoff nel loro mondo, ho dovuto aggiungere altri plugin (non so se sia legale)
- Quest'anno si usa ros2, mavros non è molto raccomandato e loro scaricano px4_msgs quindi si usa questo

### Cose utili

- `rosdep check --from-paths . --ignore-src --rosdistro humble`
- `rosdep install -y -r -q --from-paths src --ignore-src --rosdistro humble`
- ign è diverso da gz, ign è vecchio (ricordatelo quando copi comandi da internet)
- `export GZ_SIM_RESOURCE_PATH=~/work/gz_maps/worlds/:~/work/gz_maps/models/` per aggiungere path dove prendere modelli a gz
- `rqt_graph`
- `ros2 run rqt_topic rqt_topic`
- Se cose come `ros2 topic list` non funzionano (si bloccano), vuol dire che il daemon non riesce a partire, per la maggior parte dei comandi di questo tipo si può aggiungere la flag `--no-daemon` per evitare che parta
