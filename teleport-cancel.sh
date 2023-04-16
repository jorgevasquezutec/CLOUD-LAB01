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

echo "Cancel Modifyvm teleport: $vmname";
VBoxManage modifyvm $vmname --teleporter off --teleporterport $port --teleporterpassword $password