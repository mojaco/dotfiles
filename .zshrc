# Powerlevel10k instant prompt. Må ligge øverst; ting som ber om input (passord, [y/n]) må stå over denne.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# zsh-syntax-highlighting må være sist.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Unike oppføringer i PATH, også når zsh startes inne i zsh.
typeset -U path PATH
path=("$HOME/.local/bin" $path)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Maskinspesifikt oppsett (ikke i repoet).
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local
