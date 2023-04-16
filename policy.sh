#!/bin/bash

# Configuración
# source="mv2"
username="user"
password="password"
interval=5
port=1234
host="192.168.0.16"


function espera {
    echo "Esperando $1 segundos..."
    sleep $1
}


while getopts s:d: flag
do
    case "${flag}" in
        s) source=${OPTARG};;
        d) destination=${OPTARG};;
    esac
done
echo "source: $source";




#setear metricas
VBoxManage metrics setup $source Guest/CPU/Load,Guest/RAM/Usage
sleep 1
# Bucle infinito

while true
do
   
  cpu=$(VBoxManage metrics query $source Guest/CPU/Load/User | awk 'NR>2 {print $3}')
  men_total=$(VBoxManage metrics query $source Guest/RAM/Usage/Total | awk 'NR>2 {print $3}')
  men_free=$(VBoxManage metrics query $source Guest/RAM/Usage/Free | awk 'NR>2 {print $3}')  
  # echo "Total: $men_total"
  # echo "Free: $men_free"
  percent_menfree=$(echo "scale=2; ($men_total-$men_free)/$men_total" | bc -l)
  percent_menfree_pct=$(echo "$percent_menfree * 100" | bc)
  echo "Men Usage: $percent_menfree_pct%"

  #quitar % y convertir a float
  echo "CPU usage: $cpu"
  cpu_decimal=$(echo $cpu | sed 's/%//g' | bc -l)
  # echo $cpu_decimal

  if (( $(echo "$percent_menfree_pct >= 75.00 || $cpu_decimal >= 80.00" | bc -l) )); then
      echo "Ejecutar política"
      VBoxManage modifyvm $destination --teleporter on --teleporterport 1234 --teleporterpassword password
      espera 5
      VBoxManage startvm $destination --type separate
      espera 5
      echo "ejecutar teleport $source to $destination"
      VBoxManage controlvm $source teleport --host $host --port 1234 --password password  
      break
  fi
  

  sleep $interval
done

