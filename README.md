# dotfiles — livepixelz

Config zsh, git et outils — gérée via [chezmoi](https://chezmoi.io).

## Sur une nouvelle machine

```bash
# Cloner le repo (privé — SSH requis) :
git clone git@github.com:livepixelz/dotfiles.git ~/.local/share/chezmoi

# Puis lancer le script d'install :
bash ~/.local/share/chezmoi/install.sh
```

Le script installe chezmoi, tous les outils (starship, nvm, fnm, pyenv, fzf, zoxide, eza, bat, fd, rg, lazygit, tmux), les plugins zsh, puis applique les dotfiles.

## Après l'install

Une fois `install.sh` terminé, il aura déposé `~/.zsh_secrets.example`. Crée ton fichier de secrets local (jamais versionné) :

```bash
cp ~/.zsh_secrets.example ~/.zsh_secrets
nano ~/.zsh_secrets   # colle tes API keys, alias VPS, etc.
source ~/.zshrc
```

## Workflow quotidien

```bash
# Modifier un dotfile
chezmoi edit ~/.zshrc

# Voir les diff avant d'appliquer
chezmoi diff

# Appliquer
chezmoi apply

# Push vers GitHub
chezmoi cd
git add -A && git commit -m "..." && git push
```

## Fichiers trackés

| Source chezmoi | Destination |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_gitconfig.tmpl` | `~/.gitconfig` |
| `dot_gitignore_global` | `~/.gitignore_global` |
| `dot_zsh/` | `~/.zsh/` |
| `dot_zsh_secrets.example` | `~/.zsh_secrets.example` |

## Secrets (non versionnés)

`~/.zsh_secrets` contient : `OPENAI_API_KEY`, `MISTRAL_API_KEY`, `POSTGRES_URL`, alias VPS, etc.
Il est sourcé automatiquement par `.zshrc` s'il existe.

## Différences macOS / Linux

- Homebrew : installé sur macOS uniquement, apt + installers officiels sur Linux
- Sourcetree dans `.gitconfig` : conditionnel macOS
- `bat` → peut s'appeler `batcat` sur Ubuntu (symlink créé automatiquement)
- `fd` → peut s'appeler `fdfind` sur Ubuntu (symlink créé automatiquement)
