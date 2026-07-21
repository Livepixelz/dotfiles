# Piloter le Mac depuis l'iPhone (`macctl` / `macctld`)

Contrôle à distance du Mac : **veille, verrouillage, redémarrage, extinction,
anti-veille, Wake-on-LAN**, depuis l'iPhone, **partout via Tailscale**.

Deux interfaces, un seul cœur (`macctl`) :

| Interface | Pour quoi | Côté iPhone |
|-----------|-----------|-------------|
| **SSH**   | Le plus sûr, zéro service exposé | Shortcuts → « Exécuter un script via SSH » |
| **HTTP**  | Widgets/boutons tappables        | Shortcuts → « Obtenir le contenu de l'URL » |

> ⚠️ **« Allumage » = réveil depuis la veille.** Le Wake-on-LAN réveille un Mac
> **en veille**, pas **éteint**. Sur Apple Silicon, WoL est fiable surtout en
> **Ethernet** (capricieux en Wi-Fi). Un vrai démarrage à froid à distance
> nécessite du matériel externe (prise connectée). Voir [Wake-on-LAN](#wake-on-lan).

---

## 1. Activation

```bash
chezmoi edit-config          # mets features.remote_control = true
                             # renseigne [data.remote] (port, MAC pour WoL…)
chezmoi apply                # installe macctl/macctld + le job launchd
```

Le daemon `macctld` démarre au login (launchd, `KeepAlive`) et écoute **sur
l'IP Tailscale uniquement**. Logs : `~/.cache/macctld.log`.

Prérequis : [Tailscale](https://tailscale.com) installé et connecté sur le Mac
**et** l'iPhone (même tailnet). C'est ce qui rend le tout joignable depuis la 4G
sans ouvrir le moindre port.

---

## 2. Le CLI `macctl`

```
macctl status              état JSON (batterie, uptime, caffeinate, IP tailscale)
macctl sleep               met le Mac en veille
macctl displaysleep        éteint l'écran (sans verrouiller)
macctl lock                verrouille la session
macctl restart             redémarre proprement
macctl shutdown            éteint proprement
macctl caffeinate [secs]   empêche la veille (défaut: illimité)
macctl decaffeinate        ré-autorise la veille
macctl wake [MAC] [bcast]  envoie un magic packet Wake-on-LAN
macctl token               affiche le token HTTP (à coller dans Shortcuts)
macctl serve               lance le daemon HTTP au premier plan
```

Aucune commande n'exige `sudo` : `restart`/`shutdown` passent par System Events
(extinction propre, comme le menu Pomme).

---

## 3. Interface SSH (recommandée)

Pré-requis : ta clé SSH iPhone autorisée sur le Mac, et le Remote Login activé
(`Réglages ▸ Général ▸ Partage ▸ Connexion à distance`).

Dans l'app **Raccourcis** (Shortcuts) :

1. Action **« Exécuter un script via SSH »**
2. Hôte : le nom Tailscale du Mac (ex. `mac-studio` ou l'IP `100.x.y.z`)
3. Utilisateur + clé SSH
4. Script : `~/.local/bin/macctl lock` (ou `sleep`, `restart`, …)

Ajoute le raccourci à l'écran d'accueil / un widget. Un tap = une action.
`macctl status` renvoie du JSON exploitable directement dans Shortcuts.

---

## 4. Interface HTTP (widgets)

Récupère le token une fois :

```bash
macctl token
```

Routes (toutes en `POST` sauf `/status` et `/health`) :

| Route            | Méthode | Effet |
|------------------|---------|-------|
| `/health`        | GET     | test de joignabilité (sans auth) |
| `/status`        | GET     | état JSON |
| `/sleep`         | POST    | veille |
| `/displaysleep`  | POST    | écran éteint |
| `/lock`          | POST    | verrouillage |
| `/restart`       | POST    | redémarrage |
| `/shutdown`      | POST    | extinction |
| `/caffeinate`    | POST    | anti-veille (`?secs=3600` optionnel) |
| `/decaffeinate`  | POST    | ré-autorise la veille |
| `/wake`          | POST    | Wake-on-LAN (`?mac=..&bcast=..` optionnels) |

Toutes les routes (sauf `/health`) exigent l'en-tête
`Authorization: Bearer <token>`.

Exemple `curl` (remplace l'IP Tailscale et le token) :

```bash
curl -X POST -H "Authorization: Bearer $(macctl token)" \
     http://100.x.y.z:8482/sleep
```

Côté Shortcuts, action **« Obtenir le contenu de l'URL »** :

- URL : `http://100.x.y.z:8482/sleep`
- Méthode : `POST`
- En-tête : `Authorization` = `Bearer <ton-token>`

---

## 5. Wake-on-LAN

Le Mac **en veille** doit avoir « Réveil pour l'accès réseau » activé :

```bash
sudo pmset -a womp 1        # Wake on Magic Packet (Ethernet surtout)
```

**Subtilité Tailscale :** un Mac en veille n'est plus sur le tailnet, on ne peut
donc pas lui envoyer le magic packet directement depuis la 4G. Il faut un
**nœud toujours allumé sur le même LAN** que le Mac pour relayer :

- un **routeur** avec Tailscale (ou un subnet-router),
- un **Raspberry Pi**, un NAS, un autre Mac toujours actif.

Sur ce relais (aussi dans le tailnet), tu exécutes :

```bash
macctl wake aa:bb:cc:dd:ee:ff        # MAC du Mac à réveiller
```

Renseigne `remote.wol_mac` dans `chezmoi edit-config` pour pouvoir taper
juste `macctl wake`. Depuis l'iPhone, le raccourci SSH cible **le relais**, pas
le Mac endormi.

Trouver la MAC de l'interface filaire du Mac :

```bash
networksetup -getmacaddress Ethernet
```

---

## 6. Sécurité

- Le daemon **n'écoute que sur l'IP Tailscale** (`bind = tailscale`), jamais sur
  le LAN ni l'Internet. WireGuard (Tailscale) chiffre tout le transit.
- Token Bearer 256 bits dans `~/.config/macctl/token` (`chmod 600`), comparé en
  **temps constant**. Régénère-le en supprimant le fichier puis `macctl token`.
- Rien de sensible n'est commité : la config vit dans `~/.config/macctl/`.
- Durcissement optionnel : exposer le daemon via **Tailscale Serve** (HTTPS +
  identité tailnet) au lieu du port brut —
  `tailscale serve --bg 8482`.

---

## 7. Dépannage

```bash
tail -f ~/.cache/macctld.log                 # logs du daemon
launchctl print gui/$UID/com.livepixelz.macctld   # état launchd
curl http://100.x.y.z:8482/health            # joignable ?
macctl config                                # config effective (port/bind/token)
```

- **Bind sur `127.0.0.1` au lieu de l'IP Tailscale** → Tailscale n'était pas
  connecté au démarrage du daemon. `launchctl kickstart -k gui/$UID/com.livepixelz.macctld`.
- **`restart`/`shutdown` sans effet** → autorise l'automatisation « System
  Events » (Réglages ▸ Confidentialité ▸ Automatisation) au premier appel.
