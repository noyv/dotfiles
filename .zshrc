export ZSH=$HOME/.oh-my-zsh

plugins=(z.lua fzf)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

if [ "$UID" -eq 0 ]; then
   export PROMPT="%F{135}%n%f@%F{166}%m%f %F{118}%~%f %# "
else
   export PROMPT="%F{135}%n%f@%F{166}%m%f %F{118}%~%f \$ "
fi

eval "$(fnm env --use-on-cd)"

