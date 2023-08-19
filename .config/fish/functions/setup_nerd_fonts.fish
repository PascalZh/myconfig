function setup_nerd_fonts -d "Download nerd-fonts repo in ~/Downloads and install all patched fonts."
    #set fish_trace 1
    if not test -d ~/Downloads/nerd-fonts
        git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/Downloads/nerd-fonts
        and cd ~/Downloads/nerd-fonts/; ./install.sh
    end
end

