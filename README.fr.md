# claude-memory-kit

**Une mémoire persistante, qui s'améliore toute seule, pour Claude Code : des fichiers Markdown, git et quelques hooks.**

Claude Code oublie tout d'une session à l'autre. Ce kit transforme un dossier en mémoire longue de Claude : il charge tes préférences et tes fiches à chaque démarrage, note chaque correction que tu fais, enregistre tout dans git après chaque réponse, bloque les secrets avant qu'ils soient enregistrés et, si tu veux, relit chaque nuit les conversations de la veille pour en tirer des leçons.

Pas de serveur, pas de base de données, pas de compte : bash, git, jq et Claude Code.

[English version](README.md)

## Ce qu'il contient

| Élément | Rôle |
|---|---|
| `memory/` | Des fiches Markdown : `INDEX.md` (où trouver quoi), `preferences.md`, `profile.md`, `projects.md`, un `journal/` quotidien, des `workstreams/` pour les tâches longues. |
| `CLAUDE.md` | Les règles que suit Claude : lire l'index d'abord, écrire tout de suite chaque correction durable, « une erreur corrigée deux fois devient une règle », ne rien inventer. |
| Hook **startup** | Affiche la date, l'index et le haut des préférences à chaque démarrage (moins de 9 000 caractères, pour ne jamais être tronqué). |
| Hook **autosave** | Enregistre `memory/` dans git après chaque réponse ; écarte les fichiers de plus de 5 Mo. |
| **filter** | Bloque l'enregistrement si un mot de passe, une clé d'API, un IBAN, un numéro de carte ou une coordonnée personnelle apparaît. Tes motifs dans `filter-custom.txt`, les contacts génériques autorisés dans `filter-allow.txt`. |
| **guard-secret** | Prévient quand tu colles un secret dans un message (sans le répéter). |
| **guard-injection** | Dès qu'une session a lu du contenu extérieur (page web, PDF, connecteur), toute action qui envoie, publie, pousse ou supprime demande ta confirmation. |
| **guard-reply** | Relance Claude une fois quand il finit par « veux-tu que je… ? » pour une action sans risque, ou te renvoie la vérification. |
| **guard-cost** | Prévient quand tu reprends une très longue conversation après expiration du cache. |
| **pre/post-compact** | Dit au résumé de compactage quoi garder, puis renvoie vers le chantier en cours. |
| **notify** | Alertes téléphone facultatives via [ntfy](https://ntfy.sh). |
| **Audit de nuit** (facultatif) | Relit les conversations de la veille, écrit les règles et faits manquants, liste les besoins d'outils. |
| **Outillage autonome** (facultatif) | Construit ces outils, vérifie que tout marche encore, sinon annule tout. Ce qui touche `.claude/` est seulement *préparé*, pour que tu confirmes. |
| **Radar** (facultatif) | Chaque matin, 5 skills, plugins ou techniques qui t'auraient aidé hier, sources vérifiées. `radar-install.sh <date> <n>` en installe un. |

## Installation

```bash
git clone https://github.com/lucguignard/claude-memory-kit.git
cd claude-memory-kit
./install.sh ~/assistant        # n'écrase jamais un fichier existant
cd ~/assistant && claude
```

Au premier lancement, Claude Code demande d'approuver les hooks du dossier : lis `.claude/settings.json` (il n'appelle que les scripts de `scripts/`), puis accepte. Remplis ensuite `memory/profile.md` et le haut de `memory/preferences.md`, ou présente-toi simplement à Claude et laisse-le les écrire.

Les fiches et les consignes sont en anglais : dis à Claude dans quelle langue tu veux travailler, il le notera dans `preferences.md`.

Tâches de nuit : voir la section « Night jobs » du [README anglais](README.md#night-jobs-optional) et `cron.example`.

## Licence

MIT
