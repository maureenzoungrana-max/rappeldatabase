-- Création de la base de données 
create database teranga_shop;

-- entrée dans la base de données
USE teranga_shop;

-- Création des tables 
create table categorie (
    id_categorie INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(100) NOT NULL
);

create table produit (
    id_produit INT PRIMARY KEY AUTO_INCREMENT,
    designation VARCHAR(100) NOT NULL,
    prix_unitaire DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL default 0,
    id_categorie INT,
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);  

create table client (
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    date_inscription DATE 
);

create table vendeur (
    id_vendeur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    date_embauche DATE,
    salaire DECIMAL(10, 2) NOT NULL,
    id_chef int,
    FOREIGN KEY (id_chef) REFERENCES vendeur(id_vendeur) 
);

create table commande (
    id_commande INT PRIMARY KEY AUTO_INCREMENT,
    date_commande DATE NOT NULL,
    id_client INT,
    id_vendeur INT,
    mode_paiement VARCHAR(50) NOT NULL,
    statut VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_vendeur) REFERENCES vendeur(id_vendeur),
    check (mode_paiement in ('wave', 'orange money', 'especes', 'Carte')) or mode_paiement is null,
    check (statut in ('en cours', 'livree', 'annulee'))
);

create table ligne_commande (
    id_commande INT,
    id_produit INT,
    quantite INT NOT NULL,
    prix_vente DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_commande, id_produit),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit),
    CHECK (quantite > 0),
    CHECK (prix_vente >= 0)
);