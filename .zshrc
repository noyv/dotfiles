export ZSH=$HOME/.oh-my-zsh

plugins=(z.lua fzf)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='mvim'
fi

eval "$(starship init zsh)"
eval "$(fnm env)"
