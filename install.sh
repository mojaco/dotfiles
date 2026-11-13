#!/usr/bin/env bash
# Installs the zsh setup (Oh My Zsh + Powerlevel10k + plugins) and symlinks the config from this repo.
# Requires: zsh and git. Run: ./install.sh
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
CUSTOM="$ZSH_DIR/custom"

for cmd in zsh git; do
  command -v "$cmd" >/dev/null || { echo "Missing $cmd. Install it first (e.g. su -c 'apt install $cmd')."; exit 1; }
done

clone_or_pull() {  # url dir
  if [[ -d "$2/.git" ]]; then git -C "$2" pull -q --ff-only; echo "Updated: $2"
  else git clone -q --depth=1 "$1" "$2"; echo "Installed: $2"; fi
}
clone_or_pull https://github.com/ohmyzsh/ohmyzsh.git                    "$ZSH_DIR"
clone_or_pull https://github.com/romkatv/powerlevel10k.git              "$CUSTOM/themes/powerlevel10k"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git  "$CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git      "$CUSTOM/plugins/zsh-autosuggestions"

for f in .zshrc .p10k.zsh; do
  target="$HOME/$f"
  if [[ -L "$target" && "$(readlink "$target")" == "$DIR/$f" ]]; then continue; fi
  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "$target.bak-$(date +%Y%m%d%H%M%S)"; echo "Backed up: $target.bak-*"
  fi
  ln -s "$DIR/$f" "$target"; echo "Linked: $target -> $DIR/$f"
done

if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  echo; echo "The default shell is not zsh. Run: chsh -s $(command -v zsh)"
fi
echo "Done. Open a new terminal window."
