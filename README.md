# dotfiles

Shared zsh setup for my Mac and Linux machines, so the terminal looks and behaves the same everywhere.

- **[Oh My Zsh](https://ohmyz.sh/)** – zsh framework
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** – the theme that draws the prompt
- **Plugins:** `git`, [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) (colors commands as you type) and [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) (suggests commands from history, accept with →)

## What the prompt looks like

```
╭─  ~/dotfiles   main ─────────────────────────── ✔  mojaco@dataservices ─╮
╰─ ❯
```

- **Two lines:** directory and git status on top, the command goes on the line below. The cursor always starts at the left, no matter how long the path is.
- **Blank line before each prompt**, so there is space between commands.
- **Transient prompt:** old prompts shrink to just `❯`, keeping the scrollback compact.
- **`❯` is green** when the previous command succeeded and **red** when it failed.
- **`user@host` is shown in orange only over SSH** (or as root). If you see no hostname, you are on the local machine.

## Contents

| File | Purpose |
|---|---|
| `.zshrc` | Loads Oh My Zsh, the theme and the plugins, and finally `~/.zshrc.local` if it exists |
| `.p10k.zsh` | All prompt configuration (colors, segments, layout) |
| `install.sh` | Installs dependencies and symlinks the files above |

## Setting up a new machine

### Debian/Ubuntu

```sh
su -c 'apt install zsh git'        # or: sudo apt install zsh git
git clone https://github.com/mojaco/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
chsh -s /usr/bin/zsh               # make zsh the default shell
```

Log out and back in. The first start may download `gitstatusd` (a helper for git status). This only happens once.

### macOS

zsh is already the default shell.

```sh
git clone https://github.com/mojaco/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

### Containers (Docker etc.)

The repo is public, so cloning needs no GitHub login. Containers usually run as root without `sudo` or `chsh`, so start zsh directly instead:

```sh
apt-get update && apt-get install -y zsh git ca-certificates
git clone https://github.com/mojaco/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
exec zsh
```

Or in a `Dockerfile`:

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends zsh git ca-certificates \
 && git clone --depth=1 https://github.com/mojaco/dotfiles.git /root/dotfiles \
 && /root/dotfiles/install.sh
SHELL ["/bin/zsh", "-c"]
CMD ["zsh"]
```

The `chsh` reminder from `install.sh` can be ignored in a container. `gitstatusd` is downloaded the first time zsh starts, so the container needs internet access then.

The repo can live anywhere – `install.sh` links to the directory it is in.
The default is `~/dotfiles`. Exception: on the dev machine it lives in `/opt/development/dotfiles`
alongside the other projects.

### What `install.sh` does

1. Clones (or updates, if already present) Oh My Zsh, Powerlevel10k and the two plugins into `~/.oh-my-zsh`.
2. Replaces `~/.zshrc` and `~/.p10k.zsh` with **symlinks** into the repo. Existing files are moved to `*.bak-<timestamp>`.
3. Reminds you to run `chsh` if zsh is not the default shell.

The script is safe to run multiple times.

## Font

The icons and arrows in the prompt need a **Nerd Font** in the terminal app – but only on the machine you are sitting at. Servers you SSH into don't need any font.

In use: **Hack Nerd Font**, size 14 (`brew install --cask font-hack-nerd-font`). Select it in iTerm2 under *Settings → Profiles → Text → Font*. Other Nerd Fonts work too, e.g. MesloLGS NF, which Powerlevel10k recommends.

The font is set per iTerm2 profile, so check that every profile you use has a Nerd Font.

## Changing the setup

Anything specific to one machine (e.g. `brew`, aliases for a server) goes in `~/.zshrc.local`.
It is not in the repo and is loaded last by `.zshrc`.

> **This repo is public.** Don't commit passwords, tokens, internal IP addresses or hostnames. Those belong in `~/.zshrc.local`.

Since `~/.zshrc` and `~/.p10k.zsh` are symlinks, you edit the files in the repo directly:

```sh
cd ~/dotfiles && git pull           # get the latest version first
$EDITOR ~/.p10k.zsh                 # make the change
source ~/.p10k.zsh                  # see the result (or open a new tab)
git commit -am "Describe the change" && git push
```

Pushing requires a GitHub login on that machine. When committing from a new machine, set the GitHub noreply address first so your private email doesn't end up in the history:

```sh
git -C ~/dotfiles config user.email 3873652+mojaco@users.noreply.github.com
```

Pull the change on the other machines:

```sh
cd ~/dotfiles && git pull
```

Open a new terminal window afterwards.

### Useful settings in `.p10k.zsh`

| Setting | Effect |
|---|---|
| `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` | Segments on the left. `newline` adds a line break, `prompt_char` is `❯` |
| `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` | Segments on the right (status, time, `context` = user@host, etc.) |
| `POWERLEVEL9K_PROMPT_ADD_NEWLINE` | Blank line before each prompt (`true`/`false`) |
| `POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND` | Color of the hostname over SSH (currently `214`, orange) |
| `POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=` | Hides the hostname locally. Remove the line to always show it |
| `POWERLEVEL9K_ICON_PADDING` | Space around icons |
| `POWERLEVEL9K_DIR_MAX_LENGTH` | How long the directory path can get before it is shortened |

Colors are numbers 0–255. Show them all with:

```sh
for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
```

### ⚠️ Avoid `p10k configure`

The wizard rewrites `.p10k.zsh` from scratch, and the customizations above (two lines, blank line, orange hostname) are lost. Edit the file directly instead. If you do run it, check what changed with `git diff` and undo with `git checkout .p10k.zsh`.

## Troubleshooting

| Problem | Fix |
|---|---|
| Boxes or odd characters in the prompt | The terminal app lacks a Nerd Font – see [Font](#font) |
| `git push` asks for a username / *could not read Username* | Cloning and `git pull` need no login, but `push` does. Easiest: `gh auth login` and `gh auth setup-git` (macOS: `brew install gh`) |
| `git pull` fails with *divergent branches* after a history rewrite | `git fetch && git reset --hard origin/main` (local unpushed changes are lost) |
| Still bash after installing | Run `chsh -s "$(command -v zsh)"` and log out and back in |
| Want the old setup back | Restore `~/.zshrc.bak-*` and `~/.p10k.zsh.bak-*` |
