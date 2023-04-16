
[H]
- vm2 estar apagada.
- VBoxManage modifyvm vm2 --teleporter on --teleporterport 1234 --teleporterpassword password
- vm2 la prendas , te va aparecer esperando VBox buscar prender comando
- host tiene que ser tu propia ip.
- VBoxManage controlvm vm1 teleport --host 192.168.0.16 --port 1234 --password password


[Script]
- t=0 prender vm1
- t=60 ssh al vm1 comando stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 15s
- t=65 ejecutar 
	VBoxManage modifyvm vm2 --teleporter on --teleporterport 1234 --teleporterpassword password
	VBoxManage controlvm vm1 teleport --host 192.168.0.16 --port 1234 --password password
	
- t=80 ssh al vm2 comando stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 15s
- t=90 ejecutar 
	VBoxManage modifyvm vm3 --teleporter on --teleporterport 1234 --teleporterpassword password
	VBoxManage controlvm vm2 teleport --host 192.168.0.16 --port 1234 --password password
	



           [H]192.168.0.16

[vm1]              [vm2] 

