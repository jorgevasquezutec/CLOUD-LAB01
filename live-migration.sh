#!/bin/bash

source="mv1"
destination="mv2"
username="user"
password="password"
host="192.168.0.16"


function espera {
    echo "Esperando $1 segundos..."
    sleep $1
}

#Inicar $source
echo "Iniciando $source"
VBoxManage startvm $source


# # Espera 60 segundos y luego ejecuta stress-ng en $source
espera 60
echo "ejecutar stress-ng en $source"
VBoxManage guestcontrol $source run --exe /bin/stress-ng --no-wait-stdout --username user --password password  -- - cpu 4 --io 4 --vm 1 --vm-bytes 1G --timeout 30s &

espera 5
echo "ejecutar teleport $source to"
VBoxManage modifyvm $destination --teleporter on --teleporterport 1234 --teleporterpassword password
espera 5
VBoxManage startvm $destination --type separate
espera 5
echo "ejecutar teleport $source to $destination"
VBoxManage controlvm $source teleport --host $host --port 1234 --password password


