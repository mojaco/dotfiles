#!/usr/bin/env bash
# Installerer zsh-oppsettet (Oh My Zsh + Powerlevel10k + plugins) og lenker inn config fra dette repoet.
# Krever: zsh og git. Kjør: ./install.sh
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
CUSTOM="$ZSH_DIR/custom"

for cmd in zsh git; do
  command -v "$cmd" >/dev/null || { echo "Mangler $cmd. Installer det først (f.eks. su -c 'apt install $cmd')."; exit 1; }
done

clone_or_pull() {  # url mappe
  if [[ -d "$2/.git" ]]; then git -C "$2" pull -q --ff-only; echo "Oppdatert: $2"
  else git clone -q --depth=1 "$1" "$2"; echo "Installert: $2"; fi
}
clone_or_pull https://github.com/ohmyzsh/ohmyzsh.git                    "$ZSH_DIR"
clone_or_pull https://github.com/romkatv/powerlevel10k.git              "$CUSTOM/themes/powerlevel10k"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git  "$CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git      "$CUSTOM/plugins/zsh-autosuggestions"

for f in .zshrc .p10k.zsh; do
  target="$HOME/$f"
  if [[ -L "$target" && "$(readlink "$target")" == "$DIR/$f" ]]; then continue; fi
  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "$target.bak-$(date +%Y%m%d%H%M%S)"; echo "Backup: $target.bak-*"
  fi
  ln -s "$DIR/$f" "$target"; echo "Lenket: $target -> $DIR/$f"
done

if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  echo; echo "Standardskallet er ikke zsh. Kjør: chsh -s $(command -v zsh)"
fi
echo "Ferdig. Åpne et nytt terminalvindu."
