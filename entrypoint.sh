#!/bin/bash

export HOME=/home/${USER_NAME}
cd ${HOME}

if [ ! -e ${HOME}/.bashrc_profile ]; then
    echo "#!/bin/bash"       >  ${HOME}/.bash_profile
    echo ". ${HOME}/.bashrc" >> ${HOME}/.bash_profile
fi

if [ ! -e ${HOME}/ros2_ws/install ]; then
    mkdir -p ros2_ws/src
    cd ros2_ws/src
    git clone -b dashing https://github.com/ros2/launch.git
    git clone -b dashing https://github.com/ros2/ros1_bridge.git
    cd ..
    source /opt/ros/${ROS2_DISTRO_DOCKER}/setup.bash
    colcon build --symlink-install --packages-skip ros1_bridge
    source /opt/ros/${ROS_DISTRO_DOCKER}/setup.bash
    source install/setup.bash
    colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure
    cd ..
fi

tmux new-session "exec $@"
