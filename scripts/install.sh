#!/bin/bash

# Mel Installation Script

set -e

echo
echo "  ╔════════════════════════════════╗"
echo "  ║              Mel  🧀               ║"
echo "  ║ Adaptive AI Assistant for Geany   ║"
echo "  ╚════════════════════════════════╝"
echo

# Check operating system
OS=$(lsb_release -si 2>/dev/null || uname -s)

if [[ $OS => *"Ubuntu"* ]]; then
    echo "🐧 Detected Ubuntu"
    echo "Installing dependencies..."
    sudo apt-get update 
    sudo apt-get install -y build-essential geany libgtk-3-dev libgeany-dev libsqlite3-dev libcurl4-openssl-dev libjson-c-dev
    
    # Check if pre-built package is available
    URL="https://github.com/dealappseo/mel/releases/latest/download/mel_amd64.deb"
    if curl --head --silent --fail "$URL" > /dev/null 2>&1; then
        echo "📦 Installing pre-built package..."
        wget "$URL"
        sudo dpkg -i mel_amd64.deb
        echo "🚀 Mel installed successfully!"
        echo "Restart Geany and enable the Mel plugin in Tools > Plugin Manager."
        exit 0
    fi
    
elif [[ $OS == *Arch* ]]; then
    echo "🐧 Detected Arch Linux"
    echo "Installing from AUR..."
    yay -S geany-plugin-mel || { echo "❌ Failed to install from AUR, trying manual install..."; build_from_source; }
    echo "🚀 Mel installed successfully!"
    exit 0
    
else
    echo "🥥 Detected: $OS"
    echo "No pre-built package available, building from source..."
fi 

build_from_source() {
    # Download and build from source
    echo "Installing dependencies..."
    sudo apt-get install -y build-essential geany libgtk-3-dev libgeany-dev libsqlite3-dev libcurl4-openssl-dev libjson-c-dev git
    
    echo "📮 Cloning repository..."
    cd /tmp
    git clone https://github.com/dealappseo/mel.git
    cd mel
    
    echo "💁 Building..."
    make
    
    echo "🔙 Installing..."
    make install-user
    
    echo "🖧 Cleaning up..."
    cd ~
    rm -rf /tmp/mel
}

build_from_source

echo
echo "🚀 Mel installed successfully!"
echo "Restart Geany and enable the Mel plugin in Tools > Plugin Manager."
echo "🌐 Visit https://melchizedekai.com for documentation!"
echo