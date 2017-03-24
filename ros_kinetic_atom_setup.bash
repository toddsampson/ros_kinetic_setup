#!/bin/bash
set -e

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install -y ros-kinetic-ros-base
sudo rosdep init
rosdep update
source /opt/ros/kinetic/setup.bash
source ~/.bashrc
sudo apt-get install -y python-rosinstall
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
cd ~/catkin_ws/
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
echo $ROS_PACKAGE_PATH

sudo apt-get install -y arduino ros-kinetic-rosserial-arduino ros-kinetic-rosserial ros-kinetic-rosserial-server ros-kinetc-rosbridge-server openssh-server vim
mkdir -p ~/sketchbook/libraries && cd ~/sketchbook/libraries && rosrun rosserial_arduino make_libraries.py .
source ~/.bashrc

# GPS Navsat Driver
cd ~/catkin_ws/src && git clone https://github.com/ros-drivers/nmea_navsat_driver.git && cd nmea_navsat_driver && python setup.py build && sudo python setup.py install && source ~/catkin_ws/devel/setup.bash

# Vendbot
cd ~/catkin_ws/src && git clone https://github.com/toddsampson/vendbot.git

# Arduino UDEV Rules for Arduino and USB Dev Path for PlatformIO & ROS
sudo usermod -a -G dialout $USER
sudo tee /etc/udev/rules.d/99-robot.rules > /dev/null <<EDF
SUBSYSTEM=="usb", KERNEL=="ttyACM[0-9]*", ATTRS{idProduct}=="6001", ATTRS{idVendor}=="0403", GROUP="dialout"
SUBSYSTEM=="usb", KERNEL=="ttyACM[0-9]*", ATTRS{idProduct}=="2341", ATTRS{idVendor}=="8041", GROUP="dialout"
SUBSYSTEM=="usb", KERNEL=="ttyACM[0-9]*", ATTRS{idProduct}=="2341", ATTRS{idVendor}=="0044", GROUP="dialout"
ATTRS{idVendor}=="2a03", ENV{ID_MM_DEVICE_IGNORE}="1"
SUBSYSTEM=="tty", ATTRS{idProduct}=="0042", SYMLINK+="arduinomega"
EDF
sudo cp ~/catkin_ws/src/vendbot/arduino/platformio/99-platformio-udev.rules /etc/udev/rules.d/
sudo udevadm trigger

# Install PlatformIO and Setup Arduino Mega
pip install --upgrade pip
sudo pip install -U platformio
cd ~/catkin_ws/src/vendbot/arduino/platformio
platformio run --target upload

# Install OpenSSH Server
sudo systemctl start ssh.socket

# Setup Rowmower Systemd Service
sudo cp ~/catkin_ws/src/vendbot/rosmower/rosmower.service /etc/systemd/system/rosmower.service
sudo systemctl start rosmower

# Ensure Zeroconf is working
sudo apt-get install -y avahi-daemon avahi-utils
avahi-resolve -n `hostname`.local
# If that doesn't work, try: `tcpdump -i wlan0 port 5353`
