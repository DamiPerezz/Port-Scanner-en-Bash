ip="192.168.58.128"
ruta="/tmp/EscaneoPuertos"
numeroPuertos=1000

#Verificar que existe carpeta temporal para almacenamiento de resultados
if [ -e $ruta ];then
    echo "La carpeta temporal existe"
else
    echo "Creando carpeta para escaneo"
    mkdir /tmp/EscaneoPuertos
fi
echo "Iniciando escaneo de $numeroPuertos puertos"

for((i=1;i<${numeroPuertos};i++))
do
    nc -zv $ip $i > /tmp/EscaneoPuertos/salidaPuerto${i} 2>&1
done

valid_ports=("") #Array para almacenar puertos validos

for((i=1;i<${numeroPuertos};i++))
do
    ultimaPalabra=$(awk '{print $NF}' /tmp/EscaneoPuertos/salidaPuerto${i})
    if [ $ultimaPalabra == "succeeded!" ]
    then
        echo "Puerto $i abierto"
        valid_ports+=($i)
    else
        echo "Puerto $i cerrado"
    fi
done
echo "----------------------------"
echo "Escaneo finalizado con exito"
echo "----------------------------"
echo -n "Puertos abiertos -->"
for elemento in "${valid_ports[@]}"
do
    echo -n "$elemento  "
done
echo ""
echo "Liberando almacenamiento temporal..."
rm -r /tmp/EscaneoPuertos


