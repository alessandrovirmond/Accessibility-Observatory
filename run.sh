#! /bin/bash
clear
echo "Iniciando execução..."
sleep 3
rm Bot-AxeDevTools/insumo-bot-axe.xlsx 
source pythonENV/bin/activate
cd Bot-Varredura/
python3 main.py
cd ../Bot-AxeDevTools/
python3 main.py
cd ..

