if [ ! -f '$HOME/myshrc.local.sh' ];then
  touch $HOME/.myshrc.local
fi
source $HOME/.myshrc.local
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias pls='sudo'
alias fortune='fortune | lolcat'
alias rm='rm -i'
alias __create_esp_project='source ~/bin/_E_create_esp_project_E_'

# ------------------------------------------------
### Here are some interesting command tools.

# w3m
# sudo apt install w3m w3m-img

# sl
# sudo apt install sl

# fortune
# sudo apt install fortune-mod fortune-zh

# tree
# sudo apt install tree

# lolcat
# usage:
# man ... | lolcat
# fortune | lolcat
# and etc.

# cmatrix

# ack
# run perl -MCPAN -e shell
# run install App::Ack in the perl

# ------------------------------------------------

### And here are some recommendations of some useful software.

#tilda

# redshift
# it protects your eyes.

# Glyphr
# design your font
