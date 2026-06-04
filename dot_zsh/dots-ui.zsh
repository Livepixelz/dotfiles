# dots-ui — design primitives for all `dots` commands.
# Tokyo Night Storm palette · cohesive headers, icons, spinners.

# ── Palette (Tokyo Night Storm) ───────────────────────────────────────────────
typeset -gA DUI
DUI[blue]="%F{75}"      # #7aa2f7
DUI[cyan]="%F{117}"     # #7dcfff
DUI[purple]="%F{141}"   # #bb9af7
DUI[green]="%F{150}"    # #9ece6a
DUI[orange]="%F{215}"   # #ff9e64
DUI[yellow]="%F{179}"   # #e0af68
DUI[red]="%F{210}"      # #f7768e
DUI[fg]="%F{189}"       # #c0caf5
DUI[dim]="%F{102}"      # #565f89
DUI[r]="%f"             # reset
DUI[b]="%B"
DUI[u]="%U"
DUI[B]="%b"
DUI[U]="%u"

# ── Icons ─────────────────────────────────────────────────────────────────────
typeset -gA DICO
DICO[ok]="✓"
DICO[warn]="!"
DICO[err]="✗"
DICO[info]="›"
DICO[arrow]="→"
DICO[dot]="·"
DICO[bullet]="•"
DICO[chevron]="❯"
DICO[sigil]="⏣"
DICO[spark]="✦"

# ── Output primitives ─────────────────────────────────────────────────────────
dui_header() {
  local title="$1" subtitle="${2:-}"
  print -P ""
  print -P "  ${DUI[b]}${DUI[fg]}$title${DUI[r]}${DUI[B]}${subtitle:+  ${DUI[dim]}$subtitle${DUI[r]}}"
  print -P "  ${DUI[dim]}$(printf '─%.0s' {1..40})${DUI[r]}"
}

dui_section() {
  print -P ""
  print -P "  ${DUI[cyan]}${DICO[spark]}${DUI[r]} ${DUI[b]}$1${DUI[B]}"
}

dui_ok()    { print -P "    ${DUI[green]}${DICO[ok]}${DUI[r]} $1"; }
dui_warn()  { print -P "    ${DUI[yellow]}${DICO[warn]}${DUI[r]} $1"; }
dui_err()   { print -P "    ${DUI[red]}${DICO[err]}${DUI[r]} $1"; }
dui_info()  { print -P "    ${DUI[dim]}${DICO[dot]}${DUI[r]} $1"; }
dui_step()  { print -P "  ${DUI[purple]}${DICO[chevron]}${DUI[r]} $1"; }

dui_footer() {
  local msg="${1:-done}"
  print -P ""
  print -P "  ${DUI[green]}${DICO[sigil]}${DUI[r]} ${DUI[dim]}$msg${DUI[r]}"
  print -P ""
}

# Spinner for background tasks: dui_spin "label" some-command args...
# Falls back to plain "→ label … ✓" when stdout isn't a tty.
dui_spin() {
  local label="$1"; shift
  local log="/tmp/.dui-spin.$$"
  if [ ! -t 1 ]; then
    "$@" >"$log" 2>&1; local rc=$?
    if (( rc == 0 )); then
      print -P "  ${DUI[green]}${DICO[ok]}${DUI[r]} $label"
    else
      print -P "  ${DUI[red]}${DICO[err]}${DUI[r]} $label"
      tail -8 "$log" | sed 's/^/      /'
    fi
    rm -f "$log"; return $rc
  fi
  local spinner_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
  ("$@") >"$log" 2>&1 &
  local pid=$! i=0
  while kill -0 $pid 2>/dev/null; do
    local c="${spinner_chars:$((i % ${#spinner_chars})):1}"
    printf "\r\033[K  ${(%)DUI[cyan]}${c}${(%)DUI[r]} %s" "$label"
    sleep 0.08
    ((i++))
  done
  wait $pid; local rc=$?
  if (( rc == 0 )); then
    printf "\r\033[K  ${(%)DUI[green]}${DICO[ok]}${(%)DUI[r]} %s\n" "$label"
  else
    printf "\r\033[K  ${(%)DUI[red]}${DICO[err]}${(%)DUI[r]} %s\n" "$label"
    tail -8 "$log" | sed 's/^/      /'
  fi
  rm -f "$log"
  return $rc
}

# Send a native macOS notification (silent fallback elsewhere)
dui_notify() {
  local title="${1:-dotfiles}" msg="$2"
  if command -v terminal-notifier >/dev/null 2>&1; then
    terminal-notifier -title "$title" -message "$msg" -sound default -group dots >/dev/null 2>&1 &!
  elif [[ "$OSTYPE" == darwin* ]]; then
    osascript -e "display notification \"$msg\" with title \"$title\"" 2>/dev/null &!
  fi
}
