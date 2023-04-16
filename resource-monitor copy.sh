#!/bin/bash

# Configuración
# vmname="mv2"
username="user"
password="password"
interval=5


while getopts m: flag
do
    case "${flag}" in
        m) vmname=${OPTARG};;
    esac
done
echo "vmname: $vmname";




#setear metricas
VBoxManage metrics setup $vmname Guest/CPU/Load,Guest/RAM/Usage
sleep 1
# Bucle infinito

while true
do
   
  cpu=$(VBoxManage metrics query $vmname Guest/CPU/Load/User | awk 'NR>2 {print $3}')
  men_total=$(VBoxManage metrics query $vmname Guest/RAM/Usage/Total | awk 'NR>2 {print $3}')
  men_free=$(VBoxManage metrics query $vmname Guest/RAM/Usage/Free | awk 'NR>2 {print $3}')  
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
  fi
  

  sleep $interval
done

