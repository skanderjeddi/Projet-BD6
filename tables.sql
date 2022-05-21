DROP TABLE nationalite CASCADE;
DROP TABLE port CASCADE;
DROP TABLE navire CASCADE;
DROP TABLE voyage CASCADE;
DROP TABLE etape CASCADE;
DROP TABLE produit CASCADE;
DROP TABLE packing CASCADE;

CREATE TABLE nationalite (
    code_nation INT PRIMARY KEY,
    nom VARCHAR NOT NULL
);

CREATE TABLE port (
    id_port INT PRIMARY KEY,
    nom VARCHAR NOT NULL,
    nation INT NOT NULL,
    localisation VARCHAR CHECK (localisation = 'Europe' OR localisation = 'Asie' OR localisation = 'Amerique' OR localisation = 'Afrique' OR localisation = 'Oceanie'),
    coordonnees POINT NOT NULL,
    FOREIGN KEY (nation) REFERENCES nationalite (code_nation),
    taille INT NOT NULL CHECK (taille >= 0 AND taille <= 5)
);

CREATE TABLE navire (
    id_navire INT PRIMARY KEY,
    categorie INT NOT NULL CHECK (categorie >= 0 AND categorie <= 5),
    nation INT NOT NULL,
    capacite_marchandise INT NOT NULL CHECK (capacite_marchandise >= 0),
    capacite_passagers INT NOT NULL CHECK (capacite_passagers >= 0),
    FOREIGN KEY (nation) REFERENCES nationalite (code_nation),
    CHECK ((capacite_marchandise = 0 AND capacite_passagers > 0) OR (capacite_marchandise > 0 AND capacite_passagers = 0) OR (capacite_marchandise > 0 AND capacite_passagers > 0))
);

CREATE TABLE voyage (
    id_voyage INT PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    id_navire INT NOT NULL,
    port_depart INT NOT NULL,
    port_arrivee INT NOT NULL,
    type_voyage VARCHAR NOT NULL CHECK (type_voyage = 'Court' OR type_voyage = 'Moyen' OR type_voyage = 'Long'),
    categorie VARCHAR NOT NULL CHECK (categorie = 'Europe' OR categorie = 'Asie' OR categorie = 'Amerique' OR categorie = 'Afrique' OR categorie = 'Oceanie'),
    FOREIGN KEY (id_navire) REFERENCES navire (id_navire),
    FOREIGN KEY (port_depart) REFERENCES port (id_port),
    FOREIGN KEY (port_arrivee) REFERENCES port (id_port),
    CHECK (date_debut < date_fin)
);

CREATE TABLE etape (
    id_etape SERIAL PRIMARY KEY,
    id_voyage INT NOT NULL,
    numero INT NOT NULL CHECK (numero >= 0),
    id_port INT NOT NULL,
    FOREIGN KEY (id_voyage) REFERENCES voyage (id_voyage),
    FOREIGN KEY (id_port) REFERENCES port (id_port),
    UNIQUE (numero, id_voyage)
);

CREATE TABLE produit (
    id_produit INT PRIMARY KEY,
    nom VARCHAR NOT NULL,
    volume INT NOT NULL CHECK (volume >= 0),
    perissable BOOLEAN NOT NULL
);

CREATE TABLE packing (
    id_etape INT NOT NULL,
    id_produit INT NOT NULL,
    FOREIGN KEY (id_etape) REFERENCES etape (id_etape),
    FOREIGN KEY (id_produit) REFERENCES produit (id_produit),
    PRIMARY KEY(id_etape, id_produit)
);