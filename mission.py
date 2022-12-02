#!/bin/python3

from time import sleep
import rclpy
from python_interface.drone_interface import DroneInterface
from as2_msgs.msg import TrajectoryWaypoints

drone_id = "drone0"


def drone_run(drone_interface):

    dim_x = 2.0
    dim_y = 2.0
    height = 2.0

    path = [
        [dim_x, -dim_y, height],
        [dim_x,   0.0,  height],
        [dim_x,  dim_y, height],
        [0.0,    0.0, height]]

    takeoff_height = 2.0
    takeoff_speed = 0.5
    speed = 1.0
    yaw_mode = TrajectoryWaypoints.PATH_FACING

    print(f"Start mission {drone_id}")

    drone_interface.offboard()
    print("OFFBOARD")

    drone_interface.arm()
    print("ARMED")

    sleep(1.0)

    print(f"Take Off {drone_id}")
    drone_interface.follow_path(
        [[0.0, 0.0, takeoff_height*0.5], [0.0, 0.0, takeoff_height]], speed=takeoff_speed, yaw_mode=yaw_mode)
    print(f"Take Off {drone_id} done")

    print("Follow path")
    drone_interface.follow_path(
        path,
        speed=speed,
        yaw_mode=yaw_mode)
    print("Path done")

    sleep(1.0)

    print("Land")
    drone_interface.follow_path(
        [[0.0, 0.0, takeoff_height*0.5], [0.0, 0.0, 0.0]], speed=takeoff_speed, yaw_mode=yaw_mode)
    print("Land done")

    print("Clean exit")


if __name__ == '__main__':
    rclpy.init()
    n_uavs = DroneInterface(drone_id, verbose=False)

    drone_run(n_uavs)

    n_uavs.shutdown()
    rclpy.shutdown()
    exit(0)
