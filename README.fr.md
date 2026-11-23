<p align="center"><img src="assets/notebook.svg" alt="claude-memory-kit — l'assistant que je me suis fait, parce que j'en avais marre de me répéter" width="100%"></p>

<p align="center"><i>Licence MIT · bash, git, jq · <a href="README.md">English version</a> (détails techniques complets)</i></p>

---

## Salut, moi c'est Luc

Je ne suis pas développeur. Je bosse dans le marketing : gammes de produits, catalogues, réseaux sociaux, mails clients, ce genre de choses.

Il y a quelque temps, j'ai commencé à utiliser Claude Code comme assistant au quotidien, pour le boulot et pour le perso. Et un truc me rendait fou : à chaque nouvelle session, il oubliait tout. Mon ton, mes règles, mes projets, les erreurs déjà corrigées la veille. Je passais mes journées à me répéter.

Alors je me suis fait un outil pour moi. Enfin, pour être honnête, c'est Claude qui a écrit le code. Moi j'expliquais ce que je voulais, je testais tout, et je râlais beaucoup quand ça ne marchait pas.

Ce dépôt, c'est la version nettoyée de ce montage. Rien de perso ni de pro dedans, juste la mécanique.

## Comment je travaille avec

Je parle à Claude comme à un collègue. Quand un truc m'agace, je le dis une fois :

> « Arrête de me demander "tu veux que je…". Si c'est sans risque, fais-le. »

Claude l'écrit tout de suite dans un petit fichier de notes, avec la date, et me le dit en une ligne. À la session suivante, la règle est chargée avant même que je tape quoi que ce soit. Si je dois corriger deux fois la même chose, ça devient une règle permanente. C'est le deal.

Et la partie que je préfère :

- **À 5 h**, pendant que je dors, il relit les conversations de la veille. Un peu comme un entraîneur qui revoit le match : où je me suis agacé, ce que j'ai dû expliquer deux fois, ce qu'il m'a demandé pour rien. Il corrige ses notes, et s'il lui manquait un petit outil, il le construit, le vérifie, et annule tout si quelque chose casse.
- **À 6 h**, il cherche 5 skills, plugins ou astuces qui m'auraient aidé pour ce que j'ai *vraiment* fait la veille. Sources vérifiées uniquement. Si un me plaît, une commande l'installe.
- **Quand j'ouvre Claude le matin**, tout ça est déjà chargé. Je me mets au travail, c'est tout.

Ça tourne sur un vieux portable à la maison, allumé en permanence. La partie de nuit est facultative : le reste marche sur n'importe quel ordinateur.

## Comment je l'ai construit

Petit à petit, une inquiétude après l'autre. Chaque morceau du kit répond à une question que je me suis posée en l'utilisant :

- *Et si je colle une clé d'API par erreur ?* → un filtre bloque l'enregistrement si un mot de passe, une clé, un IBAN ou un numéro de carte passe, et je suis prévenu dès que j'en colle un.
- *Et si une page web demande à Claude d'envoyer mes fichiers quelque part ?* → dès qu'il a lu quelque chose d'extérieur, il doit me demander avant d'envoyer, publier ou supprimer quoi que ce soit.
- *Et si les tâches de nuit cassent tout pendant que je dors ?* → elles tournent avec une liste stricte d'outils autorisés, ne peuvent pas toucher à leurs propres règles, et tout ce qui touche aux réglages de Claude attend mon accord.
- *Pourquoi reprendre une longue conversation après une pause coûte si cher ?* → je suis prévenu, avec la suggestion de repartir sur une conversation neuve.

Tout est en Markdown dans un dossier git. Je peux ouvrir n'importe quelle note, la modifier, ou revenir en arrière. Pas de base de données, pas de compte, pas de service en ligne.

## En quoi ça peut t'aider

Si tu utilises Claude Code pour ton travail de tous les jours, et pas seulement pour coder, je pense que ça peut t'éviter la même frustration. Marketing, opérations, conseil, recherche, indépendants… si tu passes tes journées à expliquer des choses à Claude, c'est pour toi.

- **Une mémoire** — Des notes simples : un index, tes préférences, ton profil, tes projets, un journal. Chargées à chaque démarrage, enregistrées après chaque réponse.
- **Des règles qui tiennent** — Chaque correction devient une règle datée. Deux fois la même erreur = règle permanente.
- **Une relecture de nuit** — Rattrape ce que tu n'as pas signalé, corrige les notes, construit ce qui manquait.
- **Un radar du matin** — 5 outils liés à ta vraie journée, une commande pour installer.
- **Des garde-fous** — Filtre à secrets, protection contre les consignes cachées dans les pages web, alerte de coût.

## L'essayer

```bash
git clone https://github.com/lucguignard/claude-memory-kit.git
cd claude-memory-kit && ./install.sh ~/assistant
cd ~/assistant && claude
```

(L'installation n'écrase jamais un fichier existant.) Ensuite, présente-toi à Claude comme à un nouvel assistant : ce que tu fais, comment tu aimes les réponses, ce qui t'agace. Il remplit les notes pour toi.

La première fois, Claude Code demande d'approuver les hooks du dossier : lis `.claude/settings.json` (il n'appelle que les scripts de `scripts/`), puis accepte.

Il te faut Claude Code, bash, git et jq.

## Les limites, honnêtement

- Je ne l'ai utilisé que sous Linux. Les scripts sont écrits pour marcher aussi sur Mac, mais je n'ai pas pu tester. Si tu essaies, dis-le moi.
- Les tâches de nuit demandent un ordinateur allumé (et éveillé) la nuit, et consomment ton abonnement Claude comme une session normale. Elles tournent en Sonnet par défaut pour rester raisonnables, et tu peux t'en passer.
- Tes notes restent dans un dossier local. Seul sort ce que Claude Code envoie déjà, plus des alertes téléphone facultatives (via [ntfy](https://ntfy.sh)) au texte générique, jamais la conversation.
- Le filtre à secrets est un filet de sécurité, pas une garantie. Garde tes vrais mots de passe dans un gestionnaire.
- C'est mon premier projet open source. Sois indulgent, mais honnête.

## On en parle ?

Tous les retours sont bienvenus, bons ou mauvais. Ouvre une « issue » si quelque chose ne marche pas, si tu l'as essayé sur Mac, ou si tu as une idée pour la relecture de nuit.

Si ça t'évite de te répéter, une étoile aide d'autres personnes à le trouver. Merci de m'avoir lu.

— Luc

## Licence

MIT
