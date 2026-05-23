# dotfiles

Config zsh, git et outils CLI — gérée via [chezmoi](https://chezmoi.io).

macOS-first, compatible Linux (Ubuntu/Debian).

## Ce qui est inclus

| Outil | Rôle |
|---|---|
| [starship](https://starship.rs) | Prompt shell |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` intelligent |
| [atuin](https://atuin.sh) | Historique shell enrichi |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [eza](https://github.com/eza-community/eza) | `ls` amélioré |
| [bat](https://github.com/sharkdp/bat) | `cat` avec syntax highlighting |
| [fd](https://github.com/sharkdp/fd) | `find` plus rapide |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` plus rapide |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [git-delta](https://github.com/dandavison/delta) | Diff git avec highlighting |
| [btop](https://github.com/aristocratsearch/btop) | Moniteur système |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info |
| [mise](https://mise.jdx.dev) | Gestionnaire de runtimes (node, python…) |
| [yazi](https://github.com/sxyazi/yazi) | Explorateur de fichiers terminal |
| [tmux](https://github.com/tmux/tmux) | Multiplexer terminal |

## Installation

```bash
git clone git@github.com:Livepixelz/dotfiles.git ~/.local/share/chezmoi
bash ~/.local/share/chezmoi/install.sh
```

Le script installe tous les outils, les plugins zsh, et applique les dotfiles via chezmoi.

## Config privée — à créer manuellement

Le `.zshrc` source automatiquement `~/.zsh_private` s'il existe. Ce fichier n'est **pas** versionné — c'est là que tu mets tout ce qui est spécifique à ta machine ou trop personnel pour un repo public.

```bash
touch ~/.zsh_private
```

Exemple de contenu :

```zsh
# SSH Agent (ex: 1Password)
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Navigation projets
alias work='cd ~/code/mon-projet'

# Infra
alias vps1='ssh user@1.2.3.4'

# API keys
export OPENAI_API_KEY="sk-..."
```

## Workflow quotidien

```bash
chezmoi edit ~/.zshrc     # éditer
chezmoi diff              # voir les changements
chezmoi apply             # appliquer
chezmoi cd                # aller dans le repo
git add -A && git commit -m "..." && git push
```

## Fichiers trackés

| Source | Destination |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_gitconfig.tmpl` | `~/.gitconfig` |
| `dot_gitignore_global` | `~/.gitignore_global` |
| `dot_config/starship.toml` | `~/.config/starship.toml` |
| `dot_zsh/` | `~/.zsh/` |

## macOS vs Linux

- Homebrew sur macOS, apt + installers officiels sur Linux
- `bat` peut s'appeler `batcat` sur Ubuntu (symlink créé auto)
- `fd` peut s'appeler `fdfind` sur Ubuntu (symlink créé auto)
