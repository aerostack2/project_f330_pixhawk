#!/bin/bash

# Arguments
drone_namespace=$1
if [ -z "$drone_namespace" ]; then
    drone_namespace="drone0"
fi

run_mocap=$2
if [ -z "$run_mocap" ]; then
    run_mocap="true"
fi

use_sim_time=false
controller="differential_flatness" # "differential_flatness" or "speed_controller"
behavior_type="trajectory" # "position" or "trajectory"

if [[ "$controller" == "differential_flatness" ]]
then
    behavior_type="trajectory"
fi

source ./utils/launch_tools.bash

new_session $drone_namespace

new_window 'RTPS interface' "micrortps_agent -t UDP -n $drone_namespace"

new_window 'as2_pixhawk_platform' "ros2 launch as2_pixhawk_platform pixhawk_platform_launch.py \
    namespace:=$drone_namespace \
    config:=config/platform_default.yaml \
    simulation_mode:=true"

new_window 'as2_controller_manager' "ros2 launch as2_controller_manager controller_manager_launch.py \
    namespace:=$drone_namespace \
    cmd_freq:=100.0 \
    info_freq:=10.0 \
    use_bypass:=true \
    plugin_name:=controller_plugin_${controller} \
    plugin_config_file:=config/${controller}_controller.yaml"

if [[ "$using_optitrack" == "true" ]]
then
    if [ "$run_mocap" = "true" ]; then
        new_window 'mocap' "ros2 launch mocap_optitrack mocap.launch.py  namespace:=$drone_namespace"
    fi

    new_window 'as2_state_estimator' "ros2 launch as2_state_estimator state_estimator_launch.py \
        namespace:=$drone_namespace \
        plugin_name:=as2_state_estimator_plugin_mocap"
else
    new_window 'as2_state_estimator' "ros2 launch as2_state_estimator state_estimator_launch.py \
        namespace:=$drone_namespace \
        plugin_name:=as2_state_estimator_plugin_external_odom \
        plugin_config_file:=config/default_state_estimator.yaml" 
    
    new_window  'realsense_interface' "ros2 launch as2_realsense_interface as2_realsense_interface_t265_launch.py\
        namespace:=$drone_namespace \
        drone_id:=$drone_namespace  \
        device:=t265"
fi

new_window 'as2_platform_behaviors' "ros2 launch as2_platform_behaviors as2_platform_behaviors_launch.py \
    namespace:=$drone_namespace \
    follow_path_plugin_name:=follow_path_plugin_$behavior_type \
    goto_plugin_name:=goto_plugin_$behavior_type \
    takeoff_plugin_name:=takeoff_plugin_$behavior_type \
    land_plugin_name:=land_plugin_speed"

if [[ "$behavior_type" == "trajectory" ]]
then
    new_window 'traj_generator' "ros2 launch trajectory_generator trajectory_generator_launch.py  \
        namespace:=$drone_namespace"
fi