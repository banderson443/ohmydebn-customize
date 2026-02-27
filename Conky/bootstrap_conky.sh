#!/bin/bash

### D E P E N D E N C I E S ###
echo "################################################################"
echo "Installing dependencies..."
sudo apt update -qq
sudo apt install -y conky-all curl lm-sensors
if ! which conky > /dev/null 2>&1; then
    echo "ERROR: conky failed to install. Exiting."
    exit 1
fi
echo "Dependencies installed."

echo "################################################################"
echo "Stopping conky's if available"
killall conky 2>/dev/null
sleep 1

### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S ###
mkdir -p "$HOME/.config/autostart" "$HOME/.config/conky" "$HOME/.fonts"

### C L E A N I N G  U P  O L D  F I L E S ###
if find "$HOME/.config/conky" -mindepth 1 -print -quit | grep -q .; then
    echo "################################################################"
    read -rp "Everything in folder ~/.config/conky will be deleted. Are you sure? (y/n): " choice
    case "$choice" in 
        [yY]) rm -rf "$HOME/.config/conky/"* ;;
        [nN]) echo "No files have been changed in folder ~/.config/conky."; exit ;;
        *) echo "Invalid input. Script ended"; exit ;;
    esac
else
    echo "Installation folder is ready and empty. Files will now be copied."
fi

echo "################################################################"
echo "Copying files to ~/.config/conky."
cp -r * "$HOME/.config/conky/"

echo "################################################################"
echo "Ensuring conky autostarts next boot."
cp conky.desktop "$HOME/.config/autostart/start-conky.desktop"
sed -i "s|/home/\$USER|$HOME|g" "$HOME/.config/autostart/start-conky.desktop"

### F O N T S ###
FONT="Source Sans 3"
if ! fc-list | grep -iq "$FONT"; then
    echo "################################################################"
    echo "Source Sans 3 not found, attempting to install..."
    sudo apt install -y fonts-sourcesanspro 2>/dev/null || \
    sudo apt install -y fonts-open-sans 2>/dev/null || \
    echo "Could not auto-install font. Conky may not render correctly."
else
    echo "################################################################"
    echo "Font '$FONT' is already installed. Skipping font installation."
fi

### S T A R T  O F  C O N K Y ###
echo "################################################################"
echo "Starting the conky"

# Detect correct display (xrdp uses :10, local uses :0)
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:10
fi

conky -d -c "$HOME/.config/conky/LinuxLarge" 2>/dev/null

echo "################################################################"
echo "###################    T H E   E N D      ######################"
