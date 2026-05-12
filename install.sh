#!/usr/bin/env bash
# Bootstrap dotfiles livepixelz — macOS & Ubuntu/Debian
# Usage : bash install.sh
set -uo pipefail

OS="$(uname -s)"
info()    { printf "\033[0;34m[dotfiles]\033[0m %s\n" "$*"; }
success() { printf "\033[0;32m[dotfiles]\033[0m %s\n" "$*"; }
warn()    { printf "\033[0;33m[dotfiles]\033[0m %s\n" "$*"; }

# ── Config utilisateur ───────────────────────────────────────────────────────
if [ ! -f "$HOME/.config/chezmoi/chezmoi.toml" ]; then
  info "Configuration initiale..."
  read -rp "Ton nom Git : " git_name
  read -rp "Ton email Git : " git_email
  mkdir -p "$HOME/.config/chezmoi"
  cat > "$HOME/.config/chezmoi/chezmoi.toml" << EOF
[data]
  name  = "$git_name"
  email = "$git_email"
EOF
  success "Config chezmoi créée."
fi

# ── chezmoi ───────────────────────────────────────────────────────────────────
if ! command -v chezmoi >/dev/null 2>&1; then
  info "Installation de chezmoi..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
    # Persister le PATH pour les sessions futures
    grep -q '.local/bin' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  fi
fi

# ── Homebrew (macOS) / apt (Linux) ────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    info "Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  info "Installation des outils via Homebrew..."
  brew install \
    starship \
    nvm \
    fnm \
    pyenv \
    fzf \
    zoxide \
    eza \
    bat \
    fd \
    ripgrep \
    jq \
    tmux \
    lazygit \
    fortune \
    cowsay \
    git-lfs \
    2>/dev/null || brew upgrade \
    starship fnm pyenv fzf zoxide eza bat fd ripgrep jq tmux lazygit 2>/dev/null || true

else
  # Linux (Ubuntu/Debian)
  info "Mise à jour apt..."
  sudo apt-get update -qq
  sudo apt-get install -y \
    curl wget git jq tmux zsh \
    build-essential libssl-dev \
    || true

  # Starship
  if ! command -v starship >/dev/null 2>&1; then
    info "Installation de starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  fi

  # fnm
  if ! command -v fnm >/dev/null 2>&1; then
    info "Installation de fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash
  fi

  # pyenv
  if ! command -v pyenv >/dev/null 2>&1; then
    info "Installation de pyenv..."
    curl https://pyenv.run | bash
  fi

  # fzf
  if ! command -v fzf >/dev/null 2>&1; then
    info "Installation de fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
  fi

  # zoxide
  if ! command -v zoxide >/dev/null 2>&1; then
    info "Installation de zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  # eza
  if ! command -v eza >/dev/null 2>&1; then
    info "Installation de eza..."
    sudo apt-get install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
      | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt-get update -qq && sudo apt-get install -y eza
  fi

  # bat
  if ! command -v bat >/dev/null 2>&1; then
    info "Installation de bat..."
    sudo apt-get install -y bat || true
    # Sur Ubuntu bat s'appelle parfois batcat
    if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
      mkdir -p ~/.local/bin
      ln -sf "$(command -v batcat)" ~/.local/bin/bat
    fi
  fi

  # fd
  if ! command -v fd >/dev/null 2>&1; then
    sudo apt-get install -y fd-find || true
    if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
      mkdir -p ~/.local/bin
      ln -sf "$(command -v fdfind)" ~/.local/bin/fd
    fi
  fi

  # ripgrep
  if ! command -v rg >/dev/null 2>&1; then
    sudo apt-get install -y ripgrep || true
  fi

  # lazygit
  if ! command -v lazygit >/dev/null 2>&1; then
    info "Installation de lazygit..."
    LG_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LG_VERSION}/lazygit_${LG_VERSION}_Linux_x86_64.tar.gz" \
      | tar xz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/lazygit
  fi
fi

# ── NVM (commun macOS + Linux) ────────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  info "Installation de nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# ── Plugins zsh (fast-syntax-highlighting, zsh-autosuggestions) ───────────────
ZSH_CUSTOM="$HOME/.zsh"
mkdir -p "$ZSH_CUSTOM"

if [ ! -d "$ZSH_CUSTOM/fast-syntax-highlighting" ]; then
  info "Installation de fast-syntax-highlighting..."
  git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "$ZSH_CUSTOM/fast-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/zsh-autosuggestions" ]; then
  info "Installation de zsh-autosuggestions..."
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM/zsh-autosuggestions"
fi

# ── Appliquer les dotfiles via chezmoi ────────────────────────────────────────
info "Application des dotfiles..."
chezmoi apply --force

# ── .zsh_secrets ─────────────────────────────────────────────────────────────
if [ ! -f "$HOME/.zsh_secrets" ]; then
  warn ".zsh_secrets absent — copie le template et remplis tes tokens :"
  warn "  cp ~/.zsh_secrets.example ~/.zsh_secrets && \$EDITOR ~/.zsh_secrets"
fi

success "Installation terminée 🎉"
success "Lance : source ~/.zshrc"
