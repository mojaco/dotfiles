# Powerlevel10k instant prompt. Must stay at the top; anything that asks for input (passwords, [y/n]) must go above this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# zsh-syntax-highlighting must be last.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Unique PATH entries, even when zsh is started inside zsh.
typeset -U path PATH
path=("$HOME/.local/bin" $path)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Machine-specific setup (not in the repo).
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local
