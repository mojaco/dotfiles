# dotfiles

zsh-oppsett: Oh My Zsh + Powerlevel10k (to-linjers prompt, classic-stil) med
`zsh-syntax-highlighting` og `zsh-autosuggestions`.

## Ny maskin

```sh
git clone <repo-url> ~/dotfiles
~/dotfiles/install.sh
chsh -s "$(command -v zsh)"   # hvis zsh ikke allerede er standardskall
```

Krever `zsh` og `git` (Debian: `su -c 'apt install zsh git'`).

## Endre oppsettet

`~/.zshrc` og `~/.p10k.zsh` er symlenker til dette repoet. Endre, så `git commit` + `git push`.
På de andre maskinene: `cd ~/dotfiles && git pull`.

Fonten (Nerd Font) trengs bare på maskinen med terminalvinduet, ikke på servere.
