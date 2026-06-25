# Fix : `dots update` qui freeze sur « syncing chezmoi »

## Symptôme

```
❯ dots update
  dots update  chezmoi + brew + mise
  ────────────────────────────────────────
[4] 32934
  ⠏ syncing chezmoi[4]  + suspended (tty output)  ( "$@"; ) > "$log" 2>&1
  ⠼ syncing chezmoi
```

Le spinner tourne indéfiniment et la commande ne rend jamais la main. Un process
`chezmoi update` reste en arrière-plan à l'état stoppé (`T`) et garde le **lock
de state chezmoi**, ce qui fait échouer les `chezmoi` suivants avec :

```
chezmoi: timeout obtaining persistent state lock, is another instance of chezmoi running?
```

## Cause

`dui_spin` (dans `dot_zsh/dots-ui.zsh`) lance la commande en tâche de fond sans
détacher stdin du terminal :

```zsh
("$@") >"$log" 2>&1 &
```

stdout/stderr sont redirigés vers le log, mais **stdin reste le tty**. Quand
`chezmoi update` (ou un de ses sous-process : git, ssh, un hook) lit le tty ou
modifie ses réglages via `tcsetattr`, le job — qui n'est pas dans le process
group de premier plan — reçoit `SIGTTIN` / `SIGTTOU` et passe à l'état
**stopped** (`suspended (tty output)`).

Le job est *stoppé*, pas terminé : `kill -0 $pid` reste vrai → la boucle du
spinner ne sort jamais. Et le process suspendu conserve le lock chezmoi.

> À noter : l'auth SSH (`git pull`) n'est **pas** en cause ici — elle fonctionne
> en non-interactif (`BatchMode=yes`). Le piège est purement le couple
> tty/background du spinner.

## Correctif

Rediriger stdin du job de fond vers `/dev/null` dans `dui_spin` :

```diff
- ("$@") >"$log" 2>&1 &
+ ("$@") >"$log" 2>&1 </dev/null &
```

Toute tentative de lecture du tty reçoit alors un EOF (au lieu de suspendre le
job), et le `tcsetattr` sur stdin n'a plus de tty à manipuler. La commande
échoue proprement au lieu de geler, et le spinner se termine normalement.

Si une étape a réellement besoin d'une saisie interactive (déblocage de clé SSH,
etc.), utiliser le mode verbeux qui tourne en premier plan :

```bash
dots update -v
```

## Procédure de récupération (si déjà freezé)

```bash
# 1. tuer le chezmoi suspendu qui tient le lock
ps aux | grep -i chezmoi | grep -v grep   # repérer le PID à l'état T
kill -9 <pid>

# 2. ouvrir un nouveau shell (ou re-sourcer) pour recharger dui_spin
source ~/.zsh/dots-ui.zsh

# 3. relancer
dots update
```

## Fichier touché

- `dot_zsh/dots-ui.zsh` — fonction `dui_spin`
