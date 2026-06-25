# sketchybar

Status bar config — Kanagawa palette, Aerospace workspaces, contextual app menu popup.

## Layout

```
~/.config/sketchybar/
├── sketchybarrc       # entry point — sources items in order
├── colors.sh          # palette
├── lib/helpers.sh     # right_item() — shared pill style
├── items/             # one file per logical group
│   ├── bar.sh         # bar + defaults
│   ├── appmenu.sh     # left logo + popup (PRs, next event, system)
│   ├── spaces.sh      # Aerospace workspaces
│   ├── front_app.sh
│   ├── media.sh       # center: Apple Music now-playing
│   └── right.sh       # all right-side pills
├── plugins/           # update scripts (called by sketchybar on tick/event)
├── icons/             # logo + custom assets
└── bin/               # DX tools
    ├── reload         # fast respawn (replaces brew services restart)
    ├── watch          # fswatch auto-reload on file change
    ├── query          # pretty-print item state
    ├── test-plugin    # run a plugin in isolation
    └── install        # check deps
```

## Quickstart

```bash
~/.config/sketchybar/bin/install   # check deps
~/.config/sketchybar/bin/reload    # apply config
```

Add to PATH for convenience:

```bash
export PATH="$HOME/.config/sketchybar/bin:$PATH"
```

Then: `reload`, `watch`, `query github`, `test-plugin media`.

## Development

- **Edit a pill** → `items/<name>.sh` for the declaration, `plugins/<name>.sh` for the update logic.
- **Add a right pill** → in `items/right.sh`, use `right_item <name> <args>`.
- **Live dev** → run `bin/watch` in a terminal, edit any file, it reloads automatically.
- **Debug a plugin** → `bin/test-plugin <name>` runs it with `set -x` and prints resulting state.
- **Inspect state** → `bin/query <name>` for full JSON, `bin/query <name> label.value` for a field.

## Apps integrated

- **GitHub** (`gh search prs`) — pill shows PRs you authored, popup shows PRs awaiting your review
- **Apple Music** (AppleScript) — center pill, now-playing track
- **Aerospace** — workspace pills, click to switch
- **Calendar** (AppleScript) — next event in popup

## Notes

- `nowplaying-cli` returns `<redacted>` since macOS 15.4 — media plugin falls back to direct AppleScript on Music.app.
- Logo SVG → PNG via `rsvg-convert -h 44 -w 44 icons/livepixelz.svg -o icons/livepixelz.png`.
