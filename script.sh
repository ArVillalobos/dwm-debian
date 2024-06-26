#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Install Terminus Fonts
sudo apt install fonts-terminus

# Set the font to Terminus Fonts
setfont /usr/share/consolefonts/Uni3-TerminusBold28x14.psf.gz

# Clear the screen
clear

apt install nala -y

# Installing Essential Programs 
nala install feh kitty locate rofi git thunar nitrogen curl lxpolkit x11-xserver-utils unzip wget pipewire wireplumber build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev xdg-utils -y
# Installing Other less important Programs
nala install neofetch flameshot vim lxappearance papirus-icon-theme lxappearance fonts-noto-color-emoji lightdm bash bash-completion tar tree multitail tldr -y


# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir 
nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

systemctl enable lightdm
systemctl set-default graphical.target

otherDeps() {
    if ! curl -sS https://starship.rs/install.sh | sh; then
        echo "Algo salió mal instalando starship "
        exit 1
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    sudo mv squashfs-root /opt/neovim
    sudo ln -s /opt/neovim/AppRun /usr/bin/nvim

     if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
        echo -e "${RED}Something went wrong during zoxide install!${RC}"
        exit 1
    fi

}

otherDeps

cd $builddir
cp ./configs/starhip.toml ~/.config/starship.toml
cp -r ./configs/kitty ~/.config/

cd dwm-guero
make clean install
cp dwm.desktop /usr/share/xsessions

cd $builddir
bash scripts/usenala
