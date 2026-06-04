```
 ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
 ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
 ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
 ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
 ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
                                              by @Livepixelz 👁️‍🗨️
```

![preview](assets/preview.png)

> macOS-first · zsh · chezmoi · opinionated

My personal dev environment. One command to go from a fresh machine to a fully working setup.

---

## ⚡ Install

```bash
git clone git@github.com:Livepixelz/dotfiles.git ~/.local/share/chezmoi
bash ~/.local/share/chezmoi/install.sh
```

That's it. The script handles everything — tools, plugins, runtimes, dotfiles.

---

## 📦 What's inside

### 🐚 Shell
| | |
|---|---|
| [zsh](https://zsh.org) | Shell |
| [starship](https://starship.rs) | Prompt — fast, minimal, context-aware |
| [atuin](https://atuin.sh) | Shell history with search, sync, and stats |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` — jump to any dir by frecency |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder wired into everything |
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Syntax colors as you type |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like suggestions from history |

### 🔁 CLI replacements
| Instead of | Use | Why |
|---|---|---|
| `ls` | [eza](https://github.com/eza-community/eza) | Icons, git status, tree view |
| `cat` | [bat](https://github.com/sharkdp/bat) | Syntax highlighting, line numbers |
| `find` | [fd](https://github.com/sharkdp/fd) | Faster, respects `.gitignore` |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | Much faster, sane defaults |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | Learns your habits |
| `top` | [btop](https://github.com/aristocratsearch/btop) | Beautiful, actually readable |

### 🛠️ Dev tools
| | |
|---|---|
| [mise](https://mise.jdx.dev) | Runtime manager — node, python, and more |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI — never type `git rebase` again |
| [git-delta](https://github.com/dandavison/delta) | Diff with syntax highlighting |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file explorer with previews |
| [zellij](https://github.com/zellij-org/zellij) | Terminal multiplexer — layouts Vue & Zend inclus |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info on terminal open |
| [direnv](https://direnv.net) | Per-directory env vars |

---

## 🔒 Private config

`.zshrc` automatically sources `~/.zsh_secrets` if it exists. This file is **never committed** — put anything sensitive or machine-specific in there: API keys, SSH config, private aliases.

A template is included to get started:

```bash
cp ~/.local/share/chezmoi/dot_zsh_secrets.example ~/.zsh_secrets
```

```zsh
# ~/.zsh_secrets — not versioned

# SSH agent (e.g. 1Password)
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# API keys
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."

# Private aliases
alias vps1='ssh user@1.2.3.4'
alias work='cd ~/code/my-project'
```

---

## 🔄 Daily workflow

```bash
chezmoi edit ~/.zshrc   # edit a dotfile
chezmoi diff            # preview changes
chezmoi apply           # apply to home dir
chezmoi cd              # open the repo
```

### ⚙️ Feature flags (opt-in / opt-out)

Every install step is gated by a boolean in `~/.config/chezmoi/chezmoi.toml` under `[data.features]`. Toggle then `chezmoi apply`:

```bash
chezmoi edit-config
```

| Flag | What it does | Default |
|---|---|---|
| `brew_auto_install` | Install Homebrew if missing (first apply) | `true` |
| `brew_auto_bundle` | Run `brew bundle` when `Brewfile` changes | `true` |
| `zsh_plugins_auto` | Auto-clone fast-syntax-highlighting, autosuggestions, fzf-tab, zsh-abbr | `true` |
| `mise_runtimes_auto` | Install node@lts, python@3.12, bun@latest globally | `true` |
| `install_fonts` | Install Nerd Fonts (JetBrains, Fira, Symbols) + Inter | `true` |
| `macos_defaults` | Apply Dock/Finder/keyboard/trackpad tweaks | `true` |
| `fzf_tab` | zsh completion through fzf | `true` |
| `zsh_abbr` | Fish-like abbreviation expansion | `true` |
| `global_git_hooks` | Activate `~/.config/git/hooks` (gitleaks pre-commit) | `true` |
| `direnv_helpers` | `use_doppler`, `layout_node`, `use_op_secret` helpers | `true` |
| `onepassword` | `op_secret` helper in zsh + use op CLI for secrets | `false` |
| `atuin_sync` | Enable atuin auto-sync to `atuin.sync_address` | `false` |

### 🎛️ The `dots` command

A unified command center with cohesive Tokyo Night Storm UI. `dots` (or `d`) is your single entry point:

```bash
# Sync
dots status      # local drift + remote diff
dots pull        # fetch + apply
dots push        # re-add + commit + push (msg arg optional)
dots apply       # chezmoi apply -v

# Health
dots doctor      # binaries, plugins, sync state
dots stats       # repo at a glance (onefetch if installed)

# Maintenance
dots update      # chezmoi + brew + mise (silent, -v for full logs)
dots backup      # snapshot to ~/Backups/*.tar.zst (keeps last 10)
dots edit        # fzf-pick a managed file, open in chezmoi edit
dots config      # edit ~/.config/chezmoi/chezmoi.toml
dots cd          # cd into the source repo

# Explore
dots diff        # colored diff source ↔ home (via delta)
dots search      # fzf fuzzy search across managed files
dots docs        # render README in glow

# Productivity
dots focus       # toggle DnD + quit Slack/Discord/Mail
dots audit       # check permissions on sensitive files + gitleaks scan
dots bench       # profile zsh startup time (hyperfine)

# Discover
dots welcome     # tour & active features
```

### ⏰ Scheduled jobs (launchd, opt-in via `features.scheduled_jobs`)

| Job | When | What |
|---|---|---|
| `dots-update` | daily 9:00 | `chezmoi update` + `brew upgrade` |
| `dots-backup` | Sunday 3:30 | weekly snapshot to `~/Backups/` |
| `brewfile-dump` | daily 10:00 | re-dump Brewfile (catch new brews automatically) |

Logs land in `~/.cache/dots-*.log`. Toggle via `dots config`.

Legacy aliases (`dots-status`, `dots-pull`, etc.) still work. macOS-native notifications fire on sync events via `terminal-notifier`.

### 🔁 GitHub sync

Once a day (at terminal startup, debounced via `~/.cache/dotfiles-check.stamp`), zsh checks:
- **Remote ahead?** → `📥 dotfiles: N commits behind origin — run dots-pull`
- **Local drifted?** → `📤 dotfiles: N files modified locally — run dots-push`

Commands:

```bash
dots-status   # show local drift + remote diff
dots-pull     # chezmoi update (git pull + apply)
dots-push     # chezmoi re-add, then commit + push (optional message arg)
```

---

## 📁 Tracked files

| Repo | Home |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_gitconfig.tmpl` | `~/.gitconfig` |
| `dot_gitignore_global` | `~/.gitignore_global` |
| `dot_zsh/` | `~/.zsh/` |
| `dot_config/starship.toml` | `~/.config/starship.toml` |
| `dot_config/btop/` | `~/.config/btop/` |
| `dot_config/zellij/` | `~/.config/zellij/` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/bat/` | `~/.config/bat/` |
| `dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| `dot_config/posting/` | `~/.config/posting/` |
| `dot_config/zed/settings.json` | `~/.config/zed/settings.json` |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` (600) |
| `Brewfile` | — (run `brew bundle`) |
| `run_once_darwin-defaults.sh.tmpl` | — (run once on apply) |

### 🎨 App themes & preferences — Tokyo Night Storm everywhere

| App | Theme |
|---|---|
| Ghostty | `tokyonight_storm` (built-in) |
| Zed | Tokyo Night Storm (built-in family) |
| btop | `tokyonight_storm.theme` (bundled) |
| bat | `tokyonight_storm.tmTheme` (bundled, rebuilt via `run_onchange_after_bat-cache.sh`) |
| zellij | `tokyonight_storm.kdl` (bundled) |
| Posting | `tokyonight_storm.yaml` (bundled) |
| lazygit | full theme in `config.yml` |
| git-delta | uses bat's `tokyonight_storm` syntax theme |
| fzf | palette via `FZF_DEFAULT_OPTS` in zshrc |

Not tracked (intentionally):
- **Raycast** — state lives in encrypted SQLite. Use `run_once_darwin-defaults.sh` for `defaults write com.raycast.macos …` if needed
- **Obsidian** — real settings live in `.obsidian/` per vault. Version them inside each vault

### 🍺 Brewfile

`Brewfile` is generated via `brew bundle dump --force`. To reinstall the full stack on a new machine:

```bash
brew bundle --file=~/.local/share/chezmoi/Brewfile
```

Refresh the file when adding packages:
```bash
brew bundle dump --file=~/.local/share/chezmoi/Brewfile --force
```

### 🍎 macOS defaults

`run_once_darwin-defaults.sh.tmpl` applies sensible defaults (Dock, Finder, screenshots, keyboard repeat, trackpad) on **first apply only**. Bump the filename to re-run.

### 🔑 SSH config (templated)

`~/.ssh/config` is generated from `private_dot_ssh/private_config.tmpl` using data from `~/.config/chezmoi/chezmoi.toml` (never committed). On a new machine, `chezmoi init` will prompt for:

- `vps1_ip`, `vps2_ip`, `vps_user` — your VPS hosts (leave empty to skip)
- `storagebox`, `storagebox_user` — Hetzner Storage Box (optional)

To edit values later:

```bash
chezmoi edit-config       # opens ~/.config/chezmoi/chezmoi.toml
chezmoi apply             # regenerates ~/.ssh/config
```

---

## 🐧 macOS vs Linux

- Homebrew on macOS, apt + official installers on Linux
- `bat` → `batcat` on Ubuntu (symlinked automatically)
- `fd` → `fdfind` on Ubuntu (symlinked automatically)
