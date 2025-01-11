#! /bin/bash
#! /bin/bash
GOOGLE="/usr/bin/google-chrome-stable"

if [ ! -f "$GOOGLE"  ] 
then
    clear
    echo "Instalando o Google Chrome"
    sleep 3
    wget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./tmp/google-chrome-stable_current_amd64.deb -y
fi

clear
echo "Instalando ou atualizando dependencias"
sleep 3
sudo apt update
sudo apt install python3 python3-pip google-chrome-stable libxi6 libgconf-2-4 libxss1 libappindicator1 fonts-liberation libasound2 libnspr4 libnss3 xdg-utils unzip -y

clear 
echo "Preparando ambiente..."
sleep 3
python3 -m venv pythonENV
source pythonENV/bin/activate
pip install --upgrade pip
pip install selenium webdriver-manager axe-selenium-python googletrans pandas keyboard
pip install requests openpyxl
