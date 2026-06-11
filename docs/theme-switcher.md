# Theme switcher

Switch terminal/editor theme across all configured apps in one shot.

## Usage

```bash
theme                  # affiche le thème courant
theme --list           # liste les thèmes supportés
theme catppuccin_macchiato # switch
```

Thèmes supportés : `tokyonight_storm`, `catppuccin_macchiato`, `rose_pine`, `kanagawa`.

## Comment ça marche

1. Le thème courant est stocké dans `~/.config/chezmoi/chezmoi.toml` (`[data.theme] name`).
2. Chaque config app est un template chezmoi (`.tmpl`) qui résout le nom du thème via les helpers de `.chezmoitemplates/theme-<app>`.
3. Le script `theme <name>` édite le TOML, lance `chezmoi apply`, et reload ce qui peut l'être.

## Apps couvertes par le switcher

| App | Mécanisme |
|---|---|
| Ghostty | `theme = …` dans `~/.config/ghostty/config` |
| Zellij | `theme "…"` dans `~/.config/zellij/config.kdl` |
| Helix | `theme = "…"` dans `~/.config/helix/config.toml` |
| Bat | `--theme="…"` dans `~/.config/bat/config` |
| Btop | `color_theme = "…"` dans `~/.config/btop/btop.conf` |
| Posting | `theme: …` dans `~/.config/posting/config.yaml` |
| Lazygit | palette hex complète dans `config.yml` (inline switch) |
| Zed | `theme.dark = "…"` dans `settings.json` (inline switch, nom officiel Zed) |

## ⚠️ Fichiers de thème à installer

Le switcher change la **référence** dans la config. Il faut que le **fichier de thème** existe pour chaque app. Voici l'état :

### Déjà OK (builtins ou déjà installés)
- **Ghostty** : `tokyonight_storm` custom (présent), `catppuccin-macchiato`, `rose-pine`, `kanagawa-wave` sont builtins (`ghostty +list-themes`).
- **Helix** : `tokyonight_storm`, `catppuccin_macchiato`, `rose_pine`, `kanagawa` tous builtins.
- **Btop** : `tokyonight_storm` présent, autres dispos via [btop themes](https://github.com/aristocratos/btop/tree/main/themes).
- **Lazygit** : palette inline, aucun fichier externe requis.
- **Zed** : `Tokyo Night Storm`, `Rosé Pine` builtins. **Catppuccin Macchiato** et **Kanagawa** → installer via le panneau Extensions.

### À installer manuellement

- **Zellij** : seul `tokyonight_storm.kdl` est présent dans `~/.config/zellij/themes/`. Ajouter :
  - `catppuccin-macchiato.kdl` → <https://github.com/catppuccin/zellij>
  - `rose-pine.kdl` → <https://github.com/rose-pine/zellij>
  - `kanagawa.kdl` → <https://github.com/dmtrKovalenko/kanagawa-zellij> (ou variant)

- **Bat** : `tokyonight_storm` est custom. Pour les autres, soit utilise un nom builtin (`bat --list-themes`), soit ajoute des `.tmTheme` dans `~/.config/bat/themes/` puis `bat cache --build`. `Catppuccin Macchiato` peut nécessiter <https://github.com/catppuccin/bat>.

- **Posting** : seul `tokyonight_storm.yaml` présent dans `~/.config/posting/themes/`. Créer les autres `<theme>.yaml`.

## Reload runtime

Le script reload ce qu'il peut, le reste demande une action manuelle :

| App | Reload |
|---|---|
| Ghostty | redémarre l'app (ou `Cmd+Shift+,` reload config) |
| Zellij | tue/relance la session (config lue au démarrage) |
| Helix | `:config-reload` dans l'éditeur |
| Bat | immédiat (relu à chaque appel) |
| Btop | immédiat au prochain lancement |
| Posting | watcher actif si `watch_themes: true` |
| Lazygit | redémarre lazygit |
| Zed | reload auto (watcher fichier) |
