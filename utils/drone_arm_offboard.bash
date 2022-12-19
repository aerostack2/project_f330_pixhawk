#!/bin/bash

ros2 service call /drone_0/set_offboard_mode std_srvs/srv/SetBool data:\ true\

ros2 service call /drone_0/set_arming_state std_srvs/srv/SetBool data:\ true\