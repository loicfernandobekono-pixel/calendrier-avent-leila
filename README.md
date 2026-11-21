# 24 jours plus près de toi — calendrier de l'Avent

Site mobile-first pour Léïla. Calendrier de 24 portes avec déblocage quotidien du 1er au 24 décembre 2026, espace de préparation, édition des textes et médias.

## État du projet
Le dépôt contient le front-end. Le mode aperçu fonctionne sans configuration. Pour activer la connexion administrateur, la synchronisation entre appareils et les médias, il faut connecter un projet Supabase.

## Configuration Supabase
1. Créer un projet sur https://supabase.com.
2. Dans **SQL Editor**, exécuter intégralement le fichier `supabase/schema.sql`.
3. Dans **Project Settings → API**, copier Project URL et la clé **anon/public** (jamais la service_role).
4. Dans `index.html`, remplacer `REMPLACER_PAR_URL_SUPABASE` et `REMPLACER_PAR_CLE_ANON_SUPABASE`.
5. Déployer à nouveau le site.
6. Dans l'espace préparation, créer le compte administrateur avec une adresse e-mail contrôlée par le créateur. Désactiver les inscriptions publiques dans Supabase Auth après création du compte.

## Sécurité et confidentialité
- Le dépôt GitHub et le site GitHub Pages sont publics.
- Les portes non encore débloquées sont filtrées aussi par la politique RLS de la base de données, selon la date de Paris.
- Les médias du bucket sont publics par URL pour permettre leur lecture sans compte ; ne téléverser que des médias que le créateur accepte de rendre accessibles publiquement.
- Ne jamais mettre de clé `service_role`, mot de passe ou donnée secrète dans le dépôt.
- L'interface ne constitue pas une protection des contenus tant que Supabase n'est pas configuré et que le compte admin n'est pas créé.

## Déploiement GitHub Pages
Le workflow `.github/workflows/pages.yml` publie automatiquement le contenu du dépôt sur GitHub Pages à chaque push sur `main`. Dans GitHub, vérifier **Settings → Pages → Build and deployment → Source: GitHub Actions**.
