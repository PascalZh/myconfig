# daily use

# :terminal :! in neovim need the following environment set to work normally.
set -gx LC_ALL "en_US.UTF-8"
set -gx IDF_PATH "/home/laozhang/esp/esp-idf"
#bash /opt/ros/noetic/setup.bash

function P_wsl_ip
  echo (ip route | grep default | awk '{print $3}')
end
function P_set_proxy
  set -gx https_proxy http://(P_wsl_ip):10809
  set -gx http_proxy http://(P_wsl_ip):10809
end

function P_set_display_vcxsrv
  set -gx DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
end

function P_set_display_wsl
  set -gx DISPLAY :0
end

P_set_proxy
set -a -gx PATH $HOME/julia-1.7.2/bin
set -gx JULIA_NUM_THREADS auto
set -a -gx PATH $HOME/.cargo/bin
#set -a -x PATH /usr/local/lib/nodejs/node-v12.16.0-linux-x64/bin
set -a -gx PATH $HOME/bin
set -a -gx PATH $HOME/.local/bin

if status --is-interactive
  #alias ll 'ls -alhF'
  #alias la 'ls -A'
  #alias l 'ls -CF'
  alias ls 'exa'
  alias ll 'exa --long -F -a'
  alias l 'exa -F'
  alias rm 'rm -i'
  alias cat 'batcat --paging=never'

  # -a: --add; -g: --global
  abbr -a -g vim 'nvim'
  abbr -a -g pls 'sudo'
  abbr -a -g t 'tree -h'

  abbr -a -g gs 'git status'
  abbr -a -g ga 'git add'
  abbr -a -g gco 'git checkout'
  abbr -a -g gcm 'git commit -m'
  abbr -a -g gl 'git lslog'
  abbr -a -g gd 'git diff'

  abbr -a -g sai 'sudo apt install'
  abbr -a -g sar 'sudo apt remove'

  abbr -a -g cff 'nvim ~/.config/fish/config.fish'
  abbr -a -g cfui 'nvim ~/.config/bspwm/bspwmrc ~/.config/sxhkd/sxhkdrc ~/.compton.conf'

  abbr -a -g scf 'source ~/.config/fish/config.fish'

  # cool features
  abbr -a -g fortune 'fortune | lolcat'

  # various use of particular tasks
  abbr -a -g create_esp_project 'source ~/bin/_E_create_esp_project_E_'
  abbr -a -g download_gogh \
  'wget -O gogh https://git.io/vQgMr && chmod +x gogh'
  abbr -a -g matlab_ "matlab -nodesktop -nojvm"
  abbr -a -g leelaz '~/program_files/leela-zero/build/leelaz'
  abbr -a -g leelaz_ \
  '~/program_files/leela-zero/build/leelaz -w \
  ~/program_files/leela-zero/build/best-network \
  --cpu-only --gtp --noponder -t 4 -p 1'

  alias get_idf 'source $HOME/esp/esp-idf/export.fish'
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

function mount_windows_shared_folder
  sudo mount -t cifs -o username=PascalZh,password=,uid=pascal //192.168.31.82/biyesheji ~/Share
end

function P_git_clone

  if test (count $argv) -eq 1
    git clone https://github.com/PascalZh/$argv[1].git
  else if test (count $argv) -eq 2
    git clone https://github.com/$argv[1]/$argv[2].git
  else
    echo arguments are more than 2!
  end

end

function P_install_my_tools

  P_install dialog
  P_install curl

  dialog --checklist "Install some common softwares" 0 0 5 \
  "get_nvim"        "get newest NVIM nightly(unstable) and put it in /usr/local/bin"         off \
  "setup_nvim"      "install pynvim and open nvim, you should run install commands manually" off \
  "z_lua_for_fish"  "clone z.lua in ~/.local/share and install z.lua for fish"               off \
  "nodejs"          "show how to install nodejs"                                             off \
  "gui"             "install bspwm, rofi, zathura, feh, sxhkd, compton"                      off \
  2> /tmp/dialogtmp
  if test $status = 0
    if grep -w "get_nvim" /tmp/dialogtmp
      curl -fLo ~/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
      sudo chmod u+x ~/nvim.appimage
      sudo mv ~/nvim.appimage /usr/local/bin/nvim
    end

    if grep -w "setup_nvim" /tmp/dialogtmp
      # install pip via get-pip.py
      if not which pip 1>/dev/null
        curl -sSL https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py
        sudo python3 ~/get-pip.py
      end

      python3 -m pip install --user --upgrade pynvim
      nvim +q
    end

    if grep -w "z_lua_for_fish" /tmp/dialogtmp
      P_install lua5.3
      if test ! -d ~/.config/fish/conf.d
        mkdir ~/.config/fish/conf.d
      end
      P_git_clone skywind3000 z.lua
      and rm -rf  ~/.local/share/z.lua
      and mv z.lua ~/.local/share
      and echo "source (lua ~/.local/share/z.lua/z.lua --init fish | psub)" \
      > ~/.config/fish/conf.d/z.fish
    end

    if grep -w "nodejs" /tmp/dialogtmp
       xdg-open https://github.com/nodejs/help/wiki/Installation
    end

    if grep -w "gui" /tmp/dialogtmp
      P_install feh
      P_install zathura  ; P_install rofi

      P_install bspwm    ; P_install sxhkd
      P_install compton
    end

  end

  # Some useful command
  P_install neofetch
  #P_install screenfetch
  P_install ack
  P_install ncdu
  P_install cloc          # count line of codes
  # btop          # replacement for htop
  P_install dos2unix

  # Useful new tools
  P_install fd-find
  P_install tldr
  P_install bat

  # Install delta
  if not echo (apt -qq list delta 2>/dev/null) | grep installed
    curl -fLo ~/git-delta_0.12.1_amd64.deb https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb
    sudo dpkg -i ~/git-delta_0.12.1_amd64.deb
  end

  # Install btop
  if not which btop 1>/dev/null
    git clone https://github.com/aristocratos/btop.git ~/btop
    cd ~/btop
    sudo apt install coreutils sed git build-essential gcc-11 g++-11
    make CXX=g++-11
    sudo make install
  end

  # C++
end

function P_install
  if test -z $argv[1]
    return
  end
  set info (apt -qq list $argv[1] 2>/dev/null)
  echo -e "P_install:\033[32m apt -qq list $argv[1]\033[0m ==> $info"
  if not echo $info | grep installed
    echo -e "\033[33mInstalling $argv[1]\033[0m"
    sudo apt install -y $argv[1]
  end
end

function P_compdb
  compdb -p build/ list > compile_commands.json
end

function P_show_cheatsheet
  echo "# Cheatsheet of Linux system
### disable bold font in gnome-terminal, try tab to complete the long code below
```bash
dconf write /org/gnome/terminal/legacy/profiles:/:a372873d-7fcd-4f50-9566-6aa3c0870ea8/allow-bold  false
```

"
end

