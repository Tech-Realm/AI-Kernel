#!/bin/bash

ACTION=$1

if [ "$ACTION" == "install" ]; then
    echo "Building the driver..."
    make
    echo "Installing the driver..."
    sudo insmod ai_kernel_driver.ko
    echo "Driver installed."
elif [ "$ACTION" == "uninstall" ]; then
    echo "Uninstalling the driver..."
    sudo rmmod ai_kernel_driver
    make clean
    echo "Driver uninstalled."
else
    echo "Usage: $0 {install|uninstall}"
    exit 1
fi
