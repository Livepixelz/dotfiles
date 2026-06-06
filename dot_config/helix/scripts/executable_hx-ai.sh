#!/usr/bin/env bash
# Pipe stdin (Helix selection) to Claude Code with a specific prompt.
# Usage: hx-ai.sh <action>   where action ∈ explain|refactor|fix|test|review
# Toggle via ~/.config/helix/.ai-disabled (touch to disable)

set -euo pipefail

if [[ -f "$HOME/.config/helix/.ai-disabled" ]]; then
  cat
  exit 0
fi

action="${1:-explain}"
input="$(cat)"

case "$action" in
  explain)
    prompt="Explique ce code en 2-3 phrases max, en français. Sois concis. Ne renvoie QUE l'explication, sans le code."
    mode="comment"
    ;;
  refactor)
    prompt="Refactore ce code pour qu'il soit plus simple, idiomatique et concis. Garde le comportement identique. Renvoie UNIQUEMENT le code refactoré, sans backticks, sans explications."
    mode="replace"
    ;;
  fix)
    prompt="Corrige les bugs dans ce code. Renvoie UNIQUEMENT le code corrigé, sans backticks, sans explications."
    mode="replace"
    ;;
  test)
    prompt="Génère un test unitaire (bun:test ou vitest selon le contexte) pour ce code. Renvoie UNIQUEMENT le code du test, sans backticks, sans explications."
    mode="append"
    ;;
  review)
    prompt="Review ce code en français. Liste max 3 problèmes concrets (bugs, sécurité, perf). Sois bref. Ne renvoie QUE la review, sans le code."
    mode="comment"
    ;;
  *)
    echo "$input"
    exit 0
    ;;
esac

response="$(printf '%s' "$input" | claude -p "$prompt" 2>/dev/null || echo "")"

if [[ -z "$response" ]]; then
  echo "$input"
  exit 0
fi

# Strip code fences if Claude added them anyway
response="$(printf '%s' "$response" | sed -e 's/^```[a-zA-Z]*$//' -e 's/^```$//' | sed '/^$/N;/^\n$/D')"

case "$mode" in
  replace)
    printf '%s' "$response"
    ;;
  append)
    printf '%s\n\n%s' "$input" "$response"
    ;;
  comment)
    # Prefix with // for comment-style output above the original
    commented="$(printf '%s' "$response" | sed 's|^|// |')"
    printf '%s\n%s' "$commented" "$input"
    ;;
esac
