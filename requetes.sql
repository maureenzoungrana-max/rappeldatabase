-- PARTIE A: Définir la structure (LDD) 

-- 1 : Creer la table livraison
CREATE TABLE livraison (
    id_livraison INT PRIMARY KEY,
    id_commande INT NOT NULL,
    date_livraison DATE NOT NULL,
    frais INT NOT NULL DEFAULT 1000,
    zone VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande)
);

-- 2a : Ajouter la colonne quartier
ALTER TABLE client
ADD quartier VARCHAR(40);

-- 2b : Afficher la structure de client
DESCRIBE client;

-- 2c : Supprimer la colonne quartier
ALTER TABLE client
DROP COLUMN quartier;

-- 3 : Interdire les emails en double
ALTER TABLE client
ADD CONSTRAINT unique_email UNIQUE (email);
-- UNIQUE interdit les doublons d'emails.

--4a : Inserer un produit
INSERT INTO produit
VALUES (601, 'Cahier 200 pages', 0, 100, 6);
-- Acceptee si l'identifiant 601 est libre, si la categorie 6 existe et si les autres contraintes sont respectees.

-- 4b : Inserer une commande pour le client 99
INSERT INTO commande
VALUES (1021, '2026-07-01', 99, NULL, 'WAVE', 'EN COURS');
-- Refusee si le client 99 n'existe pas.  La cle etrangere id_client doit referencer  un client existant. id_vendeur = NULL est autorise

-- 4c : Inserer un client sans email
INSERT INTO client
VALUES (13, 'Sy', 'Coumba', 'Kedougou',
        '771234501', NULL, '2026-07-01');
-- Acceptee si id_client = 13 est libre et si les autres contraintes sont respectees. L'email peut etre NULL car il est facultatif. Si A2 a ete execute, il faut tenir compte de la nouvelle colonne quartier ou la supprimer avant d'utiliser cette syntaxe avec VALUES.

-- 4d : Inserer une commande avec le paiement PAYPAL
INSERT INTO commande
VALUES (1021, '2026-07-01', 3, NULL, 'PAYPAL', 'EN COURS');
-- Refusee car le mode de paiement PAYPAL n'est pas autorise par la contrainte CHECK. Seuls les modes de paiement 'wave', 'orange money', 'especes' et 'Carte' sont autorises.


-- 4e : Inserer un produit dans une commande
INSERT INTO ligne_commande
VALUES (1001, 101, 1, 16500);
-- Acceptee si la commande 1001 et le produit 101 existent et si les autres contraintes sont respectees. La cle primaire est composee de id_commande et id_produit. Il n'est pas possible d'avoir deux lignes de commande pour le meme produit dans la meme commande.

-- 4f : Supprimer le client 1
DELETE FROM client
WHERE id_client = 1;
-- Acceptee si le client 1 n'est pas reference dans une commande. Sinon, la suppression est refusee par la contrainte de cle etrangere de la table commande.

--  4g : Supprimer le client 12
DELETE FROM client
WHERE id_client = 12;
-- Acceptee si le client 12 n'est pas reference dans une commande. Sinon, la suppression est refusee par la contrainte de cle etrangere de la table commande.

-- Partie B — Manipuler les données (LMD)
-- B1 : Inserer une nouvelle cliente
INSERT INTO client
VALUES (13, 'Sy', 'Coumba', 'Kedougou',
        '771234513', NULL, CURRENT_DATE());


-- B2 : Augmenter de 5 % les prix des produits electroniques
UPDATE produit
SET prix_unitaire = prix_unitaire * 1.05
WHERE id_categorie = 2;

-- Verifier les produits de la categorie Electronique
SELECT *
FROM produit
WHERE id_categorie = 2;


-- B3 : Livrer les commandes en cours passees avant le 15 juin 2026
UPDATE commande
SET statut = 'LIVREE'
WHERE statut = 'EN COURS'
  AND date_commande < '2026-06-15';

-- Afficher les commandes modifiees pour verification
SELECT *
FROM commande
WHERE statut = 'LIVREE'
  AND date_commande < '2026-06-15';


-- B4a : Supprimer le client numero 12
DELETE FROM client
WHERE id_client = 12;

-- B4b : Essayer de supprimer le client numero 1
DELETE FROM client
WHERE id_client = 1;


-- B5 : Supprimer les lignes de commande de la commande 1014
DELETE FROM ligne_commande
WHERE id_commande = 1014;

-- Supprimer ensuite la commande 1014
DELETE FROM commande
WHERE id_commande = 1014;

-- Partie c : Interroger une seule table
-- C1 : Afficher les produits du plus cher au moins cher
SELECT designation, prix_unitaire
FROM produit
ORDER BY prix_unitaire DESC;

-- C2 : Afficher les clients de Dakar ou de Thies, tries par nom
SELECT nom, prenom, ville
FROM client
WHERE ville IN ('Dakar', 'Thies')
ORDER BY nom ASC;

-- C3 : Afficher les produits dont le prix est entre 5000 et 20000 FCFA
SELECT *
FROM produit
WHERE prix_unitaire BETWEEN 5000 AND 20000;

-- C4 : Afficher les clients dont le nom commence par D
SELECT *
FROM client
WHERE nom LIKE 'D%';

-- C5 : Afficher les clients sans adresse email
SELECT *
FROM client
WHERE email IS NULL;

-- C6 : Afficher les villes des clients sans doublons, par ordre alphabetique
SELECT DISTINCT ville
FROM client
ORDER BY ville ASC;

-- C7 : Afficher les 3 produits les plus chers
SELECT *
FROM produit
ORDER BY prix_unitaire DESC
LIMIT 3;

-- C8 : Afficher les commandes passees en ligne au premier semestre 2026
SELECT *
FROM commande
WHERE id_vendeur IS NULL
  AND date_commande BETWEEN '2026-01-01' AND '2026-06-30';

-- C9 : Calculer la valeur du stock et afficher celles superieures a 200000 FCFA
SELECT designation,
       prix_unitaire * stock AS valeur_stock
FROM produit
WHERE prix_unitaire * stock > 200000
ORDER BY valeur_stock DESC;

-- Partie D — Jointures internes

-- D1a : Afficher chaque produit avec sa categorie (syntaxe JOIN)
SELECT p.designation, c.libelle
FROM produit p
JOIN categorie c ON p.id_categorie = c.id_categorie;


-- D1b : Afficher chaque produit avec sa categorie (ancienne syntaxe)
SELECT p.designation, c.libelle
FROM produit p, categorie c
WHERE p.id_categorie = c.id_categorie;


-- D2 : Afficher les commandes de la cliente Awa Diop
SELECT co.id_commande, co.date_commande, co.statut
FROM commande co
JOIN client cl ON co.id_client = cl.id_client
WHERE cl.nom = 'Diop'
  AND cl.prenom = 'Awa';


-- D3 : Afficher les clients ayant achete le Smartphone 128 Go et la date
SELECT DISTINCT cl.nom, cl.prenom, co.date_commande
FROM client cl
JOIN commande co ON cl.id_client = co.id_client
JOIN ligne_commande lc ON co.id_commande = lc.id_commande
JOIN produit p ON lc.id_produit = p.id_produit
WHERE p.designation = 'Smartphone 128 Go';


-- D4 : Afficher le detail des lignes de la commande 1006
SELECT p.designation,
       lc.quantite,
       lc.prix_vente,
       lc.quantite * lc.prix_vente AS montant
FROM ligne_commande lc
JOIN produit p ON lc.id_produit = p.id_produit
WHERE lc.id_commande = 1006;


-- D5 : Afficher chaque vendeur avec son chef direct
SELECT v.nom, v.prenom,
       ch.nom AS nom_chef,
       ch.prenom AS prenom_chef
FROM vendeur v
LEFT JOIN vendeur ch ON v.id_chef = ch.id_vendeur;


-- D6 : Afficher une seule fois chaque client de Dakar ayant paye avec Wave
SELECT DISTINCT cl.nom, cl.prenom
FROM client cl
JOIN commande co ON cl.id_client = co.id_client
WHERE cl.ville = 'Dakar'
  AND co.mode_paiement = 'WAVE';

-- Partie E — Fonctions d'agrégation et regroupements
-- E1 : Compter les produits et calculer les prix minimum, maximum et moyen
SELECT COUNT(*) AS nombre_produits,
       MIN(prix_unitaire) AS prix_minimum,
       MAX(prix_unitaire) AS prix_maximum,
       ROUND(AVG(prix_unitaire)) AS prix_moyen
FROM produit;


-- E2 : Compter les commandes pour chaque statut
SELECT statut, COUNT(*) AS nombre_commandes
FROM commande
GROUP BY statut;


-- E3 : Compter les clients par ville, du plus grand au plus petit nombre
SELECT ville, COUNT(*) AS nombre_clients
FROM client
GROUP BY ville
ORDER BY nombre_clients DESC;


-- E4 : Calculer le montant total de chaque commande livree
SELECT co.id_commande,
       SUM(lc.quantite * lc.prix_vente) AS montant_total
FROM commande co
JOIN ligne_commande lc ON co.id_commande = lc.id_commande
WHERE co.statut = 'LIVREE'
GROUP BY co.id_commande
ORDER BY montant_total DESC;


-- E5 : Calculer le chiffre d'affaires par categorie pour les commandes livrees
SELECT ca.id_categorie,
       ca.libelle,
       SUM(lc.quantite * lc.prix_vente) AS chiffre_affaires
FROM categorie ca
JOIN produit p ON ca.id_categorie = p.id_categorie
JOIN ligne_commande lc ON p.id_produit = lc.id_produit
JOIN commande co ON lc.id_commande = co.id_commande
WHERE co.statut = 'LIVREE'
GROUP BY ca.id_categorie, ca.libelle
ORDER BY chiffre_affaires DESC;


-- E6 : Afficher les villes ayant au moins 2 clients
SELECT ville, COUNT(*) AS nombre_clients
FROM client
GROUP BY ville
HAVING COUNT(*) >= 2;


-- E7 : Afficher les clients ayant passe au moins 3 commandes
SELECT cl.nom, cl.prenom,
       COUNT(co.id_commande) AS nombre_commandes
FROM client cl
JOIN commande co ON cl.id_client = co.id_client
GROUP BY cl.id_client, cl.nom, cl.prenom
HAVING COUNT(co.id_commande) >= 3;


-- E8 : Afficher les vendeurs ayant realise plus de 150000 FCFA de chiffre d'affaires
SELECT v.id_vendeur, v.nom, v.prenom,
       SUM(lc.quantite * lc.prix_vente) AS chiffre_affaires
FROM vendeur v
JOIN commande co ON v.id_vendeur = co.id_vendeur
JOIN ligne_commande lc ON co.id_commande = lc.id_commande
WHERE co.statut = 'LIVREE'
GROUP BY v.id_vendeur, v.nom, v.prenom
HAVING SUM(lc.quantite * lc.prix_vente) > 150000;


-- E9 : Calculer le chiffre d'affaires par mode de paiement en 2026
SELECT co.mode_paiement,
       SUM(lc.quantite * lc.prix_vente) AS chiffre_affaires
FROM commande co
JOIN ligne_commande lc ON co.id_commande = lc.id_commande
WHERE co.statut = 'LIVREE'
  AND co.date_commande >= '2026-01-01'
  AND co.date_commande < '2027-01-01'
GROUP BY co.mode_paiement
HAVING SUM(lc.quantite * lc.prix_vente) > 100000
ORDER BY chiffre_affaires DESC;

-- Partie F — Pont vers la L2 : découverte guidée
-- F1 : Afficher tous les clients, même ceux sans commande
SELECT cl.id_client, cl.nom, cl.prenom,
       COUNT(co.id_commande) AS nombre_commandes
FROM client cl
LEFT JOIN commande co ON co.id_client = cl.id_client
GROUP BY cl.id_client, cl.nom, cl.prenom;


-- F2 : Afficher les catégories qui n'ont aucun produit
SELECT ca.id_categorie, ca.libelle
FROM categorie ca
LEFT JOIN produit p ON p.id_categorie = ca.id_categorie
WHERE p.id_produit IS NULL;


-- F3 : Afficher tous les vendeurs avec leur chef ou « Direction »
SELECT v.id_vendeur, v.nom, v.prenom,
       COALESCE(CONCAT(c.nom, ' ', c.prenom), 'Direction') AS chef
FROM vendeur v
LEFT JOIN vendeur c ON v.id_chef = c.id_vendeur;


-- F4 : Afficher les produits dont le prix dépasse le prix moyen
SELECT id_produit, designation, prix_unitaire
FROM produit
WHERE prix_unitaire > (
    SELECT AVG(prix_unitaire)
    FROM produit
);


-- F5 : Afficher le ou les produits les moins chers
SELECT id_produit, designation, prix_unitaire
FROM produit
WHERE prix_unitaire = (
    SELECT MIN(prix_unitaire)
    FROM produit
);


-- F6 : Afficher les clients qui n'ont jamais passé de commande
SELECT id_client, nom, prenom
FROM client
WHERE id_client NOT IN (
    SELECT id_client
    FROM commande
    WHERE id_client IS NOT NULL
);


-- F7 : Réunir les contacts clients et vendeurs dans une liste unique
SELECT nom, prenom, 'Client' AS type_contact
FROM client

UNION

SELECT nom, prenom, 'Vendeur' AS type_contact
FROM vendeur

ORDER BY nom;


-- F8 : Classer les produits par gamme selon leur prix
SELECT id_produit, designation, prix_unitaire,
       CASE
           WHEN prix_unitaire < 5000 THEN 'Économique'
           WHEN prix_unitaire <= 30000 THEN 'Standard'
           ELSE 'Premium'
       END AS gamme
FROM produit
ORDER BY prix_unitaire;

-- Partie G — Débusquer l'erreur 
-- G1 : MIN() ne s'utilise pas directement dans WHERE.
SELECT *
FROM produit
WHERE prix_unitaire = (
    SELECT MIN(prix_unitaire)
    FROM produit
);


-- G2 : AND est impossible ici, car une commande ne peut pas avoir simultanément les identifiants 1001 et 1002.
SELECT DISTINCT cl.nom
FROM client cl
JOIN commande co ON co.id_client = cl.id_client
WHERE co.id_commande IN (1001, 1002);


-- G3 : nom n'est ni agrégé ni présent dans GROUP BY.
SELECT ville, COUNT(*) AS nombre_clients
FROM client
GROUP BY ville;


-- G4 : NULL se teste avec IS NULL, et non avec = NULL.
SELECT nom, prenom
FROM client
WHERE email IS NULL;


-- G5 : WHERE ne peut pas filtrer directement le résultat de COUNT(*).
SELECT id_client, COUNT(*) AS nb
FROM commande
GROUP BY id_client
HAVING COUNT(*) >= 3;


-- G6 : sans condition de jointure, chaque produit est associé
SELECT p.designation, ca.libelle
FROM produit p
JOIN categorie ca ON p.id_categorie = ca.id_categorie;


-- G7 : COUNT(*) compte aussi la ligne créée par le LEFT JOIN
SELECT cl.nom, cl.prenom, COUNT(co.id_commande) AS nb
FROM client cl
LEFT JOIN commande co ON co.id_client = cl.id_client
GROUP BY cl.id_client, cl.nom, cl.prenom;