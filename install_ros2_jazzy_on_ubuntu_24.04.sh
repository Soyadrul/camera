#!/usr/bin/env bash

# Upgrade the system
sudo apt update
sudo apt upgrade -y

# Check if you have a locale that supports UTF-8
if [[ $(locale | grep "UTF-8") ]]; then
    echo -e "\nLocales support UTF-8\n"
else
    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

# First ensure that the Ubuntu Universe repository is enabled
sudo apt install -y software-properties-common
sudo add-apt-repository universe

# Add the ROS 2 GPG key with apt
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Add the repository to your sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install development tools
sudo apt update && sudo apt install -y ros-dev-tools

# Install ROS 2 Jazzy
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-jazzy-desktop



### EXTRA ###

# Configuring environment
BASHRC=$HOME/.bashrc
grep -F "source /opt/ros/jazzy/setup.bash" $BASHRC || echo "source /opt/ros/jazzy/setup.bash" >> $BASHRC
grep -F "export ROS_DOMAIN_ID=100" $BASHRC || echo "export ROS_DOMAIN_ID=100" >> $BASHRC

# Install rqt
sudo apt update
sudo apt install '~nros-jazzy-rqt*'

# Install colcon
sudo apt install python3-colcon-common-extensions

# Setup colcon_cd
grep -F "source /usr/share/colcon_cd/function/colcon_cd.sh" $BASHRC || echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> $BASHRC
grep -F "export _colcon_cd_root=/opt/ros/jazzy/" $BASHRC || echo "export _colcon_cd_root=/opt/ros/jazzy/" >> $BASHRC
