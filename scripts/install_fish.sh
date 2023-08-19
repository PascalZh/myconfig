#!/usr/bin/env bash
if [ ! -d fish-shell/ ]; then
	git clone --depth=1 https://github.com/fish-shell/fish-shell.git
fi
sudo apt install -y libclang-dev build-essential cmake ncurses-dev libncurses5-dev libpcre2-dev gettext
cd fish-shell; cmake .; make; sudo make install
