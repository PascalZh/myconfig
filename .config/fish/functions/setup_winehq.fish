function setup_winehq
    sudo dpkg --add-architecture i386
    sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
    sudo apt update
    sudo apt install --install-recommends winehq-stable
end

