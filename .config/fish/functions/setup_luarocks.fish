function setup_luarocks -d "Download source codes of luarocks to Downloads/ and install from source"
    wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz
    and tar zxpf luarocks-3.9.2.tar.gz
    and cd luarocks-3.9.2
    and ./configure && make && sudo make install
    and sudo luarocks install luasocket
end

