#!/bin/bash

sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


# Setting up .zshrc and .p10k.zsh
file1_in_home=~/.zshrc
file2_in_home=~/.p10k.zsh
folder_config=config
file1_in_config=$folder_config/.zshrc
file2_in_config=$folder_config/.p10k.zsh

# Verificar si los archivos en ~/ existen
if [ -e "$file1_in_home" ] && [ -e "$file2_in_home" ]; then
    # Copiar y reemplazar archivo1
    cp -f "$file1_in_home" "$file1_in_config"
    echo "Se ha reemplazado $file1_in_config con $file1_in_home"

    # Copiar y reemplazar archivo2
    cp -f "$file2_in_home" "$file2_in_config"
    echo "Se ha reemplazado $file2_in_config con $file2_in_home"

    echo "Operación completada."
else
    echo "Error: Los archivos en ~/ no existen."
fi
