# dotfiles

Felles zsh-oppsett for Mac-en og Linux-maskinene mine, slik at terminalen ser lik ut og oppfører seg likt overalt.

- **[Oh My Zsh](https://ohmyz.sh/)** – rammeverk for zsh
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** – temaet som tegner prompten
- **Plugins:** `git`, [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) (farger på kommandoer mens du skriver) og [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) (foreslår kommandoer fra historikken, godta med →)

## Slik ser prompten ut

```
╭─  ~/dotfiles   main ─────────────────────────── ✔  mojaco@dataservices ─╮
╰─ ❯
```

- **To linjer:** mappe og git-status øverst, kommandoen skrives på linjen under. Markøren står alltid til venstre, uansett hvor lang stien er.
- **Tom linje før hver prompt**, så det er luft mellom kommandoene.
- **Transient prompt:** gamle prompter krympes til bare `❯`, så historikken blir kompakt.
- **`❯` er grønn** når forrige kommando gikk bra og **rød** når den feilet.
- **`bruker@maskin` vises i oransje bare over SSH** (eller som root). Ser du ikke noe maskinnavn, er du på den lokale maskinen.

## Innhold

| Fil | Hva |
|---|---|
| `.zshrc` | Laster Oh My Zsh, temaet og pluginene, og til slutt `~/.zshrc.local` hvis den finnes |
| `.p10k.zsh` | All konfigurasjon av prompten (farger, segmenter, layout) |
| `install.sh` | Installerer avhengigheter og lenker inn filene over |

## Sette opp en ny maskin

### Debian/Ubuntu

```sh
su -c 'apt install zsh git'        # eller: sudo apt install zsh git
git clone https://github.com/mojaco/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
chsh -s /usr/bin/zsh               # gjør zsh til standardskall
```

Logg ut og inn igjen. Første oppstart kan laste ned `gitstatusd` (hjelpeprogram for git-status) – det skjer bare én gang.

### macOS

zsh er allerede standardskall.

```sh
git clone https://github.com/mojaco/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Repoet kan ligge hvor som helst – `install.sh` lenker til mappen det selv ligger i.
Standard er `~/dotfiles`. Unntak: på dev-maskinen ligger det i `/opt/development/dotfiles`
sammen med de andre prosjektene.

### Hva `install.sh` gjør

1. Kloner (eller oppdaterer, hvis de finnes) Oh My Zsh, Powerlevel10k og de to pluginene til `~/.oh-my-zsh`.
2. Erstatter `~/.zshrc` og `~/.p10k.zsh` med **symlenker** inn i repoet. Eksisterende filer flyttes til `*.bak-<tidsstempel>`.
3. Minner deg på å kjøre `chsh` hvis zsh ikke er standardskall.

Skriptet kan trygt kjøres flere ganger.

## Font

Ikonene og pilene i prompten krever en **Nerd Font** i terminalprogrammet – men bare på maskinen du sitter ved. Servere du SSH-er til trenger ingen font.

I bruk: **Hack Nerd Font**, størrelse 14 (`brew install --cask font-hack-nerd-font`). Velg den i iTerm2 under *Settings → Profiles → Text → Font*. Andre Nerd Fonts fungerer også, f.eks. MesloLGS NF som Powerlevel10k anbefaler.

Fonten settes per iTerm2-profil, så sjekk at alle profilene du bruker har en Nerd Font.

## Endre oppsettet

Ting som bare gjelder én maskin (f.eks. `brew`, aliaser for en server) legges i `~/.zshrc.local`.
Den ligger ikke i repoet og lastes sist i `.zshrc`.

Fordi `~/.zshrc` og `~/.p10k.zsh` er symlenker, endrer du filene i repoet direkte:

```sh
$EDITOR ~/.p10k.zsh                 # gjør endringen
source ~/.p10k.zsh                  # se resultatet (eller åpne ny fane)
cd ~/dotfiles && git commit -am "Beskriv endringen" && git push
```

Hent endringen på de andre maskinene:

```sh
cd ~/dotfiles && git pull
```

Åpne et nytt terminalvindu etterpå.

### Nyttige innstillinger i `.p10k.zsh`

| Innstilling | Effekt |
|---|---|
| `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` | Segmenter til venstre. `newline` gir linjeskift, `prompt_char` er `❯` |
| `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` | Segmenter til høyre (status, tid, `context` = bruker@maskin osv.) |
| `POWERLEVEL9K_PROMPT_ADD_NEWLINE` | Tom linje før hver prompt (`true`/`false`) |
| `POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND` | Farge på maskinnavnet over SSH (nå `214`, oransje) |
| `POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=` | Skjuler maskinnavnet lokalt. Fjern linjen for å alltid vise det |
| `POWERLEVEL9K_ICON_PADDING` | Luft rundt ikonene |
| `POWERLEVEL9K_DIR_MAX_LENGTH` | Hvor lang mappestien kan bli før den forkortes |

Farger er tall 0–255. Se alle med:

```sh
for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
```

### ⚠️ Unngå `p10k configure`

Veiviseren skriver `.p10k.zsh` helt på nytt, og justeringene over (to linjer, tom linje, oransje maskinnavn) forsvinner. Rediger heller filen direkte. Kjører du den likevel, se hva som endret seg med `git diff` og angre med `git checkout .p10k.zsh`.

## Feilsøking

| Problem | Løsning |
|---|---|
| Firkanter eller rare tegn i prompten | Terminalprogrammet mangler Nerd Font – se [Font](#font) |
| `git pull` spør om brukernavn / *could not read Username* | Maskinen mangler GitHub-innlogging. Enklest: `gh auth login` og `gh auth setup-git` (macOS: `brew install gh`) |
| Fortsatt bash etter installasjon | Kjør `chsh -s "$(command -v zsh)"` og logg ut og inn |
| Vil tilbake til gammelt oppsett | Gjenopprett `~/.zshrc.bak-*` og `~/.p10k.zsh.bak-*` |
