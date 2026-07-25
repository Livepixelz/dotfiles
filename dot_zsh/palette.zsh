# Command palette — Ctrl+Space (ou `pal`).
# Catalogue: ~/.zsh/palette.tsv (cmd <TAB> description <TAB> catégorie)
# Sélection → insérée dans la ligne de commande (Entrée pour exécuter).

_palette_select() {
  fzf --delimiter='\t' \
      --with-nth=1,2,3 \
      --nth=1,2 \
      --height=70% --reverse --info=inline \
      --prompt='⌘  ' \
      --header='↵ insérer · le preview = tldr' \
      --preview 'c={1}; tldr --color always "${c%% *}" 2>/dev/null || "${c%% *}" --help 2>/dev/null | head -30 || echo "pas de doc"' \
      --preview-window=right:55%:wrap \
      --color='header:italic:dim' \
      < "$HOME/.zsh/palette.tsv" | cut -f1
}

pal() {
  local cmd
  cmd=$(_palette_select) || return
  [ -n "$cmd" ] && print -z -- "$cmd"
}

_palette_widget() {
  local cmd
  cmd=$(_palette_select)
  if [ -n "$cmd" ]; then
    LBUFFER+="$cmd"
  fi
  zle reset-prompt
}
zle -N _palette_widget
bindkey '^ ' _palette_widget
