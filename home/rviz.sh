
tmux split-window "source /opt/ros/${ROS_DISTRO_DOCKER}/setup.bash && \
     roscore"
tmux split-window "source /opt/ros/${ROS2_DISTRO_DOCKER}/setup.bash && \
     source ros2_ws/install/setup.bash && \
     export ROS_MASTER_URI=http://localhost:11311 && \
     ros2 run ros1_bridge dynamic_bridge --bridge-all-2to1-topics"
tmux select-layout even-vertical
source /opt/ros/${ROS_DISTRO_DOCKER}/setup.bash
rviz
