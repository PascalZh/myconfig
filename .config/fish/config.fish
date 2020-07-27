# daily use
#set -x http_proxy http://192.168.31.88:8889
#set -x https_proxy https://192.168.31.88:8888
#set -a -x PATH /usr/local/lib/nodejs/node-v12.16.0-linux-x64/bin
if status --is-interactive
    alias ll 'ls -alhF'
    alias la 'ls -A'
    alias l 'ls -CF'
    # -a: --add; -g: --global
    abbr -a -g pls 'sudo'
    abbr -a -g rm 'rm -i'
    abbr -a -g vim nvim
    abbr -a -g t tree -h

    abbr -a -g gs 'git status'
    abbr -a -g ga 'git add'
    abbr -a -g gco 'git checkout --cached'
    abbr -a -g gcm 'git commit -m'
    abbr -a -g gl 'git lslog'
    abbr -a -g gd 'git diff'

    abbr -a -g m 'make -j2'
    abbr -a -g sai sudo apt install
    abbr -a -g sar sudo apt remove

    abbr -a -g cff 'nvim ~/.config/fish/config.fish'
    abbr -a -g cfui 'nvim ~/.config/bspwm/bspwmrc ~/.config/sxhkd/sxhkdrc ~/.compton.conf'

    abbr -a -g scf 'source ~/.config/fish/config.fish'

    # cool features
    abbr -a -g fortune 'fortune | lolcat'

    # various use of particular tasks
    abbr -a -g my_create_esp_project 'source ~/bin/_E_create_esp_project_E_'
    abbr -a -g my_download_gogh \
    'wget -O gogh https://git.io/vQgMr && chmod +x gogh'
    abbr -a -g matlab_ "matlab -nodesktop -nojvm"
    abbr -a -g leelaz '~/program_files/leela-zero/build/leelaz'
    abbr -a -g leelaz_ \
    '~/program_files/leela-zero/build/leelaz -w \
    ~/program_files/leela-zero/build/best-network \
    --cpu-only --gtp --noponder -t 4 -p 1'

end

function switch_wallpaper
    python3 -c \
'
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--period", type=int,
    help="pass to watch -n PERIOD ...")
parser.add_argument("-s", "--stop", action="store_true",
    help="stop the watch -n PERIOD ... process")

args = parser.parse_args()

if args.period:
    os.system(f"watch -n {args.period} feh --randomize --bg-fill ~/Pictures/wallpaper >/dev/null &")
elif args.stop:
    os.system("ps -aux | grep \"watch -n [0-9]* feh --randomize --bg-fill\" | awk \"{print \$2}\" | xargs kill")
else:
    os.system("feh --randomize --bg-fill ~/Pictures/wallpaper")
' $argv
end

function my_mount_windows_shared_folder
    sudo mount -t cifs -o username=PascalZh,password=zhang19980918,uid=pascal //192.168.31.82/biyesheji ~/Share
end

function my_git_clone

    if test (count $argv) -eq 1
        git clone https://github.com/PascalZh/$argv[1].git
    else if test (count $argv) -eq 2
        git clone https://github.com/$argv[1]/$argv[2].git
    else
        echo arguments are more than 2!
    end

end

function my_install_my_tools

    my_check_installed dialog
    my_check_installed curl

    dialog --checklist "Install some common softwares" 0 0 5 \
    "nvim"            "get newest NVIM nightly(unstable) and put it in /usr/local/bin"         off \
    "setup_nvim"      "create init.vim; get the plug.vim installed; get all plugins installed" off \
    "z_lua_for_fish"  "clone z.lua in ~/.local/share and install z.lua for fish"               off \
    "nodejs"          "show how to install nodejs"                                             off \
    2> /tmp/dialogtmp
    if test $status = 0
        if grep -w "nvim" /tmp/dialogtmp
            #┌───────────────────────────────────┐
            #│ download nvim and install plugins │
            #└───────────────────────────────────┘
            curl -fLo ~/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
            sudo chmod u+x ~/nvim.appimage
            sudo mv ~/nvim.appimage /usr/local/bin/nvim
        end

        if grep -w "setup_nvim" /tmp/dialogtmp
            if test ! -f ~/.config/nvim/init.vim
                if test ! -d ~/.config/nvim
                    mkdir ~/.config/nvim
                end
                if test ! -d ~/.vim
                    mkdir -p ~/.vim/autoload
                end

                echo -e "set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath = &runtimepath\nsource ~/.vim/.vimrc" > ~/.config/nvim/init.vim
                echo "~/.config/nvim/init.vim created"

                curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
                nvim +PlugInstall +q +q
                echo -e "\033[33mplug.vim\033[0m installed"
            else
                echo -e "\033[33mplug.vim\033[0m already installed; you can install plugins manually"
            end
        end

        if grep -w "z_lua_for_fish" /tmp/dialogtmp
            if test ! -d ~/.config/fish/conf.d
                mkdir ~/.config/fish/conf.d
            end
            my_git_clone skywind3000 z.lua
            and rm -rf  ~/.local/share/z.lua
            and mv z.lua ~/.local/share
            and echo "source (lua ~/.local/share/z.lua/z.lua --init fish | psub)" \
            > ~/.config/fish/conf.d/z.fish
        end

        if grep -w "nodejs" /tmp/dialogtmp
            firefox https://github.com/nodejs/help/wiki/Installation
        end
    end

    # Appearance
    my_check_installed redshift-gtk ; my_check_installed feh
    my_check_installed zathura  ; my_check_installed rofi
    my_check_installed bspwm    ; my_check_installed sxhkd
    my_check_installed compton

    # Some useful command
    my_check_installed neofetch
    my_check_installed ack-grep
    my_check_installed ncdu

    # C++
end

function my_check_installed
    set flag (dpkg -s $argv[1] 2> /dev/null)
    if test -z (count flag)
        sudo apt install $argv[1]
    end
end

function my_show_cheatsheet
    echo "########
disable bold font in gnome-terminal, try tab to complete the long code below
> dconf write /org/gnome/terminal/legacy/profiles:/:a372873d-7fcd-4f50-9566-6aa3c0870ea8/allow-bold  false

########"
end
