# ros_kinetic_setup
Bash scripts to setup ROS Kinetic on Ubuntu

## Ubuntu Mate Create Disk
1. wget https://ubuntu-mate.org/raspberry-pi/ubuntu-mate-16.04.2-desktop-armhf-raspberry-pi.img.xz
2. sudo apt-get install gddrescue xz-utils
3. unxz ubuntu-mate-16.04.2-desktop-armhf-raspberry-pi.img.xz
4. lsblk # find drive… sdb, etc.
5. sudo ddrescue -D --force ubuntu-mate-16.04.2-desktop-armhf-raspberry-pi.img /dev/sdx

## Run manual setup
1. username: robot / password: *****************
2. hostname: mower# (no network)
3. ctrl+alt+f1 (switch to terminal and login)
4. sudo systemctl set-default multi-user.target # text boot
5. sudo reboot -h now
6. sudo killall wpa_supplicant
7. sudo vi /etc/network/interfaces

        auto wlan0
        iface wlan0 inet dhcp
            wpa-ssid myssid
            wpa-psk passwordhere

8. sudo chmod 0600 /etc/network/interfaces
9. sudo ifup wlan0
10. cd ~/Downloads
11. wget https://raw.githubusercontent.com/toddsampson/ros_kinetic_setup/master/ros_kinetic_atom_setup.bash
12. chmod +x ros_kinect_atom_setup.bash
13. ./ros_kinetic_atom_setup.bash

## Backup and restore Pi SD Card
1. BACKUP: sudo dd bs=4M if=/dev/sdb | gzip > /home/your_username/image`date +%d%m%y`.gz
2. RESTORE: sudo gzip -dc /home/your_username/image.gz | dd bs=4M of=/dev/sdb
