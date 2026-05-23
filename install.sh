#!/usr/bin/env bash
# Bootstrap dotfiles livepixelz — macOS & Ubuntu/Debian
# Usage : bash install.sh
set -uo pipefail

OS="$(uname -s)"
info()    { printf "\033[0;34m[dotfiles]\033[0m %s\n" "$*"; }
success() { printf "\033[0;32m[dotfiles]\033[0m %s\n" "$*"; }
warn()    { printf "\033[0;33m[dotfiles]\033[0m %s\n" "$*"; }

# ── Homebrew (macOS) / apt (Linux) ────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    info "Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  info "Installation des outils via Homebrew..."
  brew install \
    chezmoi starship nvm fnm pyenv fzf zoxide eza bat fd ripgrep \
    jq yq tmux lazygit fortune cowsay git-lfs \
    git-delta btop fastfetch mise \
    2>/dev/null || brew upgrade \
    chezmoi starship fnm pyenv fzf zoxide eza bat fd ripgrep jq yq tmux lazygit \
    git-delta btop fastfetch mise 2>/dev/null || true

else
  # Linux (Ubuntu/Debian)
  info "Mise à jour apt..."
  sudo apt-get update -qq
  sudo apt-get install -y curl wget git jq tmux zsh build-essential libssl-dev || true

  # chezmoi
  if ! command -v chezmoi >/dev/null 2>&1; then
    info "Installation de chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
    grep -q '.local/bin' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  fi

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
  if [ ! -d "$HOME/.fzf" ]; then
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
  if ! command -v bat >/dev/null 2>&1 && ! command -v batcat >/dev/null 2>&1; then
    info "Installation de bat..."
    sudo apt-get install -y bat || true
  fi
  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    mkdir -p ~/.local/bin
    ln -sf "$(command -v batcat)" ~/.local/bin/bat
  fi

  # fd
  if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
    sudo apt-get install -y fd-find || true
  fi
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p ~/.local/bin
    ln -sf "$(command -v fdfind)" ~/.local/bin/fd
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

  # Zsh comme shell par défaut
  if [ "$SHELL" != "/usr/bin/zsh" ] && command -v zsh >/dev/null 2>&1; then
    info "Passage à zsh comme shell par défaut..."
    chsh -s /usr/bin/zsh
    warn "Shell changé — déconnecte-toi et reconnecte-toi en SSH pour que zsh soit actif."
  fi
fi

# ── git-delta (Linux) ────────────────────────────────────────────────────────
if [[ "$OS" != "Darwin" ]] && ! command -v delta >/dev/null 2>&1; then
  info "Installation de git-delta..."
  DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep '"tag_name"' | sed 's/.*"\([^"]*\)".*/\1/')
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    | tar xz -C /tmp && sudo install "/tmp/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl/delta" /usr/local/bin/delta || true
fi

# ── btop (Linux) ──────────────────────────────────────────────────────────────
if [[ "$OS" != "Darwin" ]] && ! command -v btop >/dev/null 2>&1; then
  info "Installation de btop..."
  sudo apt-get install -y btop || true
fi

# ── fastfetch (Linux) ─────────────────────────────────────────────────────────
if [[ "$OS" != "Darwin" ]] && ! command -v fastfetch >/dev/null 2>&1; then
  info "Installation de fastfetch..."
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch 2>/dev/null || true
  sudo apt-get update -qq && sudo apt-get install -y fastfetch || true
fi

# ── mise (Linux) ──────────────────────────────────────────────────────────────
if ! command -v mise >/dev/null 2>&1; then
  info "Installation de mise..."
  curl https://mise.run | sh || true
fi

# ── yq (Linux) ────────────────────────────────────────────────────────────────
if [[ "$OS" != "Darwin" ]] && ! command -v yq >/dev/null 2>&1; then
  info "Installation de yq..."
  YQ_VERSION=$(curl -s "https://api.github.com/repos/mikefarah/yq/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
  sudo curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
    -o /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq || true
fi

# ── Yazi ─────────────────────────────────────────────────────────────────────
if ! command -v yazi >/dev/null 2>&1; then
  info "Installation de yazi..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install yazi || true
  else
    curl --proto '=https' --tlsv1.2 -LsSf \
      https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.tar.gz \
      | tar xz -C /tmp && sudo install /tmp/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi || true
  fi
fi

# ── Atuin ────────────────────────────────────────────────────────────────────
if ! command -v atuin >/dev/null 2>&1; then
  info "Installation de atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh || true
  # Le script atuin installe dans ~/.atuin/bin — symlink pour le rendre global
  if [ -f "$HOME/.atuin/bin/atuin" ]; then
    sudo ln -sf "$HOME/.atuin/bin/atuin" /usr/local/bin/atuin || \
      ln -sf "$HOME/.atuin/bin/atuin" "$HOME/.local/bin/atuin"
  fi
fi

# ── NVM (commun macOS + Linux) ────────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  info "Installation de nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# ── Plugins zsh ───────────────────────────────────────────────────────────────
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

# ── Config chezmoi (nom + email Git) ─────────────────────────────────────────
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

# ── Appliquer les dotfiles ────────────────────────────────────────────────────
info "Application des dotfiles..."
chezmoi apply --force

# ── .zsh_secrets ─────────────────────────────────────────────────────────────
if [ ! -f "$HOME/.zsh_secrets" ]; then
  warn ".zsh_secrets absent — crée-le depuis le template :"
  warn "  cp ~/.zsh_secrets.example ~/.zsh_secrets && nano ~/.zsh_secrets"
fi

success "Installation terminée 🎉"
if [[ "$OS" != "Darwin" ]]; then
  success "Déconnecte-toi et reconnecte-toi en SSH pour activer zsh."
else
  success "Lance : source ~/.zshrc"
fi
