DROP TABLE IF EXISTS nation CASCADE;
DROP TABLE IF EXISTS port CASCADE;
DROP TABLE IF EXISTS navire CASCADE;
DROP TABLE IF EXISTS voyage CASCADE;
DROP TABLE IF EXISTS etape CASCADE;
DROP TABLE IF EXISTS produit CASCADE;
DROP TABLE IF EXISTS cargaison CASCADE;
DROP TABLE IF EXISTS diplomatie CASCADE;

CREATE TABLE nation (
    code_nation INT PRIMARY KEY,
    nom_nation VARCHAR NOT NULL
);

CREATE TABLE port (
    id_port INT PRIMARY KEY,
    nom_port VARCHAR NOT NULL,
    nation INT NOT NULL,
    localisation VARCHAR CHECK (localisation = 'Europe' OR localisation = 'Asie' OR localisation = 'Amérique du Nord' OR localisation = 'Amérique du Sud' OR localisation = 'Afrique' OR localisation = 'Océanie' OR localisation = 'Antarctique'),
    FOREIGN KEY (nation) REFERENCES nation (code_nation),
    taille INT NOT NULL CHECK (taille >= 1 AND taille <= 5)
);

CREATE TABLE navire (
    id_navire INT PRIMARY KEY,
    categorie VARCHAR CHECK (categorie = 'Flute' OR categorie = 'Yacht' OR categorie = 'Galion' OR categorie = 'Gabare' OR categorie = 'Clipper'),
    nation INT NOT NULL,
    capacite_marchandise INT NOT NULL CHECK (capacite_marchandise >= 0),
    capacite_passagers INT NOT NULL CHECK (capacite_passagers >= 0),
    FOREIGN KEY (nation) REFERENCES nation (code_nation),
    CHECK ((capacite_marchandise = 0 AND capacite_passagers > 0) OR (capacite_marchandise > 0 AND capacite_passagers = 0) OR (capacite_marchandise > 0 AND capacite_passagers > 0))
);

CREATE TABLE voyage (
    id_voyage INT PRIMARY KEY,
    date_depart DATE NOT NULL,
    date_arrive DATE NOT NULL,
    id_navire INT NOT NULL,
    port_depart INT NOT NULL,
    port_arrivee INT,
    type_voyage VARCHAR NOT NULL CHECK (type_voyage = 'Court' OR type_voyage = 'Moyen' OR type_voyage = 'Long'),
    categorie VARCHAR CHECK (categorie = 'Europe' OR categorie = 'Asie' OR categorie = 'Amérique du Nord' OR categorie = 'Amérique du Sud' OR categorie = 'Afrique' OR categorie = 'Océanie' OR categorie = 'Antarctique' OR categorie = 'Intercontinental'),
    FOREIGN KEY (id_navire) REFERENCES navire (id_navire),
    FOREIGN KEY (port_depart) REFERENCES port (id_port),
    FOREIGN KEY (port_arrivee) REFERENCES port (id_port),
    CHECK (date_depart < date_arrive)
);

CREATE TABLE produit (
    id_produit INT PRIMARY KEY,
    nom VARCHAR NOT NULL,
    volume_kg INT NOT NULL CHECK (volume_kg >= 0),
    prix_kg INT,
    perissable BOOLEAN NOT NULL
);

CREATE TABLE etape (
    id_etape SERIAL PRIMARY KEY,
    id_voyage INT NOT NULL,
    numero INT NOT NULL CHECK (numero >= 0),
    id_port INT NOT NULL,
    passagers INT,
    FOREIGN KEY (id_voyage) REFERENCES voyage (id_voyage),
    FOREIGN KEY (id_port) REFERENCES port (id_port),
    UNIQUE (numero, id_voyage)
);

CREATE TABLE cargaison (
    id_etape INT NOT NULL,
    id_produit INT NOT NULL,
    quantite_produit INT NOT NULL,
    FOREIGN KEY (id_etape) REFERENCES etape (id_etape),
    FOREIGN KEY (id_produit) REFERENCES produit (id_produit),
    PRIMARY KEY (id_etape, id_produit)
);

CREATE TABLE diplomatie (
    nation_1 INT NOT NULL,
    nation_2 INT NOT NULL,
    relation_diplomatique VARCHAR CHECK (relation_diplomatique = 'Alliés Commerciaux' OR relation_diplomatique = 'Alliés' OR relation_diplomatique = 'Neutres' OR relation_diplomatique = 'En Guerre'),
    FOREIGN KEY (nation_1) REFERENCES nation (code_nation),
    FOREIGN KEY (nation_2) REFERENCES nation (code_nation),
    PRIMARY KEY (nation_1, nation_2)
);

\COPY nation FROM './CSV/nation.csv' CSV;
\COPY produit FROM './CSV/produit.csv' CSV;
\COPY port FROM './CSV/port.csv' CSV;
\COPY navire FROM './CSV/navire.csv' CSV;
\COPY voyage FROM './CSV/voyage.csv' CSV;
\COPY diplomatie FROM './CSV/diplomatie.csv' CSV;
\COPY etape FROM './CSV/etape.csv' WITH NULL AS 'null' CSV;
\COPY cargaison FROM './CSV/cargaison.csv' CSV;

/**
 1-n + 1-n table de transition
**/