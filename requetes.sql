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

