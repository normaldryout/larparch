#!/bin/bash

# 0. Configurações do Teu Repositório
REPO_URL="https://github.com/normaldryout/larparch.git"
TEMP_DIR="/tmp/larparch_assets"

# 1. Checagem de Root
[[ $EUID -ne 0 ]] && echo "Erro: Roda com sudo" && exit 1

# 2. Garantir Dependências
if ! command -v git > /dev/null 2>&1; then
    pacman -S --noconfirm git
fi

# 3. Baixar os Assets
rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# 4. Hijack do Nome (Agora no /etc e no /usr/lib para o Neofetch não bugar)
for file in /etc/os-release /usr/lib/os-release; do
    if [ -f "$file" ]; then
        sed -i 's/^NAME=.*/NAME="LarpArch Linux"/' "$file"
        sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="LarpArch RP"/' "$file"
        sed -i 's/^ID=.*/ID=larparch/' "$file"
        sed -i 's/^ID_LIKE=.*/ID_LIKE=larparch/' "$file"
    fi
done

# 5. Instalação das Logos e ASCII
mkdir -p /usr/share/pixmaps/larparch
cp "$TEMP_DIR/logohigh.png" /usr/share/pixmaps/larparch/logo.png
# Adicionando o ASCII no diretório de sistema como você pediu
if [[ -f "$TEMP_DIR/larparch_ascii.txt" ]]; then
    cp "$TEMP_DIR/larparch_ascii.txt" /usr/share/pixmaps/larparch/larparch_ascii.txt
fi

# 6. Instalação dos Wallpapers
mkdir -p /usr/share/backgrounds/larparch
cp "$TEMP_DIR"/wallpaper*.jpg /usr/share/backgrounds/larparch/ 2>/dev/null

# 7. Aplicar ASCII Art no MOTD/Issue
if [[ -f "/usr/share/pixmaps/larparch/larparch_ascii.txt" ]]; then
    cat /usr/share/pixmaps/larparch/larparch_ascii.txt > /etc/motd
    cat /usr/share/pixmaps/larparch/larparch_ascii.txt > /etc/issue
    echo -e "\nLarpArch Linux - Kernel \r (\l)\n" >> /etc/issue
fi

# 8. Hostname e Finalização
hostnamectl set-hostname larparch
echo "--------------------------------------------------"
echo "   METAMORFOSE CONCLUÍDA NO SISTEMA TODO!        "
echo "--------------------------------------------------"

if [[ -f "/usr/share/pixmaps/larparch/larparch_ascii.txt" ]]; then
    cat /usr/share/pixmaps/larparch/larparch_ascii.txt
fi

echo -e "\nLarpArch ativa. O Arch Linux foi devidamente expurgado."
rm -rf "$TEMP_DIR"
