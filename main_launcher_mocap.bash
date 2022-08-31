#!/bin/bash

drone_namespace="drone0"

source ./launch_tools.bash

new_session $drone_namespace
new_window 'RTPS interface' "micrortps_agent  -d /dev/ttyUSB0 -n $drone_namespace"
new_window 'viewer' "ros2 run alphanumeric_viewer alphanumeric_viewer_node --ros-args -r  __ns:=/$drone_namespace"

new_window 'pixhawk interface' "ros2 launch pixhawk_platform pixhawk_platform_launch.py \
    namespace:=$drone_namespace \
    config:=config/platform_default.yaml"

new_window 'state_estimator' "ros2 launch basic_state_estimator mocap_state_estimator_launch.py \
    namespace:=$drone_namespace "

new_window 'controller_manager' "ros2 launch controller_manager controller_manager_launch.py \
    namespace:=$drone_namespace \
    use_bypass:=true \
    config:=config/controller.yaml"

new_window 'trajectory_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$drone_namespace "

new_window 'basic_behaviours' "ros2 launch as2_basic_behaviours all_basic_behaviours_launch.py \
    drone_id:=$drone_namespace \
    config_follow_path:=config/follow_path_behaviour.yaml \
    config_takeoff:=config/takeoff_behaviour.yaml \
    config_land:=config/land_behaviour.yaml \
    config_goto:=config/goto_behaviour.yaml"

# new_window 'aruco_gate_detector' "ros2 launch aruco_gate_detector aruco_gate_detector_real_launch.py \
#     drone_id:=$drone_namespace "

# new_window 'gates_to_waypoints' "ros2 launch gates_to_waypoints gates_to_waypoints_launch.py \
#     drone_id:=$drone_namespace "

new_window  'realsense_interface' "ros2 launch realsense_interface realsense_interface_launch.py \
    drone_id:=$drone_namespace  device:=t265"


if [ -n "$TMUX" ]
  # if inside a tmux session detach before attaching to the session
then
   tmux switch-client -t $session:1
    else
  tmux attach -t $session:1
fi

