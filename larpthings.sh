#!/bin/bash

# 0. Configurações do Teu Repositório
REPO_URL="https://github.com/normaldryout/larparch.git"
TEMP_DIR="/tmp/larparch_assets"

# 1. Checagem de Root
[[ $EUID -ne 0 ]] && echo "Erro: Roda com sudo (sudo = suculendo único delicioso e original)" && exit 1

# 2. Garantir Dependências
if ! command -v git > /dev/null 2>&1; then
    echo "Instalando git..."
    pacman -S --noconfirm git
fi

# 3. Baixar os Assets do Teu GitHub
echo "Baixando logos e wallpapers de $REPO_URL..."
rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# 4. Hijack do Nome (Mantendo os links originais da distro)
# O 'sed' troca só o nome, o resto do /etc/os-release fica intacto
sed -i 's/^NAME=.*/NAME="LarpArch Linux"/' /etc/os-release
sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="LarpArch RP"/' /etc/os-release
sed -i 's/^ID=.*/ID=larparch/' /etc/os-release
sed -i 's/^ID_LIKE=.*/ID_LIKE=arch/' /etc/os-release

# 5. Instalação das Logos (.png conforme seu print)
echo "Instalando logos..."
mkdir -p /usr/share/pixmaps/larparch
cp "$TEMP_DIR/logohigh.png" /usr/share/pixmaps/larparch/logo.png
ln -sf /usr/share/pixmaps/larparch/logo.png /usr/share/pixmaps/larparch-logo.png

# 6. Instalação dos Wallpapers
echo "Instalando wallpapers..."
mkdir -p /usr/share/backgrounds/larparch
cp "$TEMP_DIR"/wallpaper*.jpg /usr/share/backgrounds/larparch/ 2>/dev/null

# 7. Aplicar ASCII Art no Terminal
if [[ -f "$TEMP_DIR/larparch_ascii.txt" ]]; then
    echo "Aplicando arte no terminal..."
    cat "$TEMP_DIR/larparch_ascii.txt" > /etc/motd
    cat "$TEMP_DIR/larparch_ascii.txt" > /etc/issue
    echo -e "\nLarpArch Linux - Kernel \r (\l)\n" >> /etc/issue
fi

# 8. Hostname e Finalização
hostnamectl set-hostname larparch
echo "--------------------------------------------------"
echo "   METAMORFOSE CONCLUÍDA COM SUCESSO!            "
echo "--------------------------------------------------"

if [[ -f "$TEMP_DIR/larparch_ascii.txt" ]]; then
    cat "$TEMP_DIR/larparch_ascii.txt"
fi

echo ""
echo "LarpArch ativa. Reinicie a sessão."
# 9. Limpeza
rm -rf "$TEMP_DIR"
