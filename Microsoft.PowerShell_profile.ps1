Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme paradox

# Mimic aliases and abbrs in fish, not perfect
New-Alias -Name vim -Value nvim

function gs { git status @args }
function ga { git add @args }
function gco { git checkout --cached @args }
function Git-Commit { git commit -m @args }
function Git-Lslog { git lslog @args }
function Git-Diff { git diff @args }

# Overriding existing alias
New-Alias -Name gcm -Value Git-Commit -Force -Option AllScope
New-Alias -Name gl -Value Git-Lslog -Force -Option AllScope
New-Alias -Name gd -Value Git-Diff -Force -Option AllScope
