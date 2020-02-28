#!/usr/bin/env fish
set w 1366
set h 769

bspc desktop -f show_off

bspc rule -a '*' state=floating

function create_cmatrix
    gnome-terminal --hide-menubar --geometry=20x10 \
    -- cmatrix -C blue && \
    bspc node -v $argv[1] $argv[2]
end

function create_random_cmatrices
    # $argv[1]: width of cmatrix window
    # $argv[2]: height of cmatrix window
    for i in (seq 1)
        set r1 (random 0 1 2000)
        set r2 (random 0 1 2000)
        set dx (python3 -c "print(round(($r1-1000)/1000*($w-$argv[1])/2))")
        set dy (python3 -c "print(round(($r2-1000)/1000*($h-$argv[2])/2))")
        #echo $dx $dy
        #sleep 0.1s
        create_cmatrix $dx $dy
    end
end

create_random_cmatrices 182 172
gnome-terminal --geometry=61x29 -- fish -C '~/.config/bspwm/dna.sh'
bspc rule -r tail
