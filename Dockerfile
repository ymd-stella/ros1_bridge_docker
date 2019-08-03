FROM ubuntu:bionic
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y tzdata gnupg2 lsb-release && \
    rm -rf /var/lib/apt/lists/*

ARG ROS2_DISTRO
ARG ROS_DISTRO
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-get update && apt-get install -y \
    ros-${ROS2_DISTRO}-desktop \
    x11-apps \
    tmux \
    build-essential \
    ccache \
    cmake \
    git \
    pkg-config \
    wget \
    unzip \
    python-pip \
    python3-dev \
    python3-pip \
    mlocate \
    sudo \
    gdb \
    libeigen3-dev \
    libboost-dev \
    libode-dev \
    nomacs \
    graphviz-dev \
    python3-colcon-common-extensions \
    ros-${ROS2_DISTRO}-tf2 \
    ros-${ROS2_DISTRO}-sensor-msgs \
    ros-${ROS2_DISTRO}-rqt-plot \
    ros-${ROS_DISTRO}-ros-base \
    ros-${ROS_DISTRO}-rviz \
    libsdl-dev libsdl-image1.2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG group_id
ARG group_name
ARG user_id
ARG user_name
RUN groupadd -g ${group_id} ${group_name}
RUN useradd --gid ${group_id} --uid ${user_id} -M -d /home/${user_name} ${user_name} -s /bin/bash
RUN echo "${user_name}:${user_name}" | chpasswd
RUN sed -i-e 's/\(%sudo.*)\)/\1 NOPASSWD:/' /etc/sudoers
RUN visudo -c

COPY entrypoint.sh /work/entrypoint.sh
RUN chmod +x /work/entrypoint.sh

ENTRYPOINT ["/work/entrypoint.sh"]
CMD ["bash"]