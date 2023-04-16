#!/bin/bash


username="user"
password="password"
interval=5
port=1234


while getopts m: flag
do
    case "${flag}" in
        m) vmname=${OPTARG};;
    esac
done

echo "Correr stress: $vmname";
VBoxManage guestcontrol $vmname run --exe /bin/stress-ng --no-wait-stdout --username user --password password  -- - cpu 4 --io 4 --vm 1 --vm-bytes 1G --timeout 30s