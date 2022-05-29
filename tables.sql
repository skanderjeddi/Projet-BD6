DROP TABLE IF EXISTS nation CASCADE;
DROP TABLE IF EXISTS port CASCADE;
DROP TABLE IF EXISTS navire CASCADE;
DROP TABLE IF EXISTS voyage CASCADE;
DROP TABLE IF EXISTS etape CASCADE;
DROP TABLE IF EXISTS produit CASCADE;
DROP TABLE IF EXISTS cargaison CASCADE;
DROP TABLE IF EXISTS diplomatie CASCADE;

CREATE TABLE nation (
    nation_code INT PRIMARY KEY,
    nation_nom VARCHAR NOT NULL
);

CREATE TABLE port (
    port_id INT PRIMARY KEY,
    port_nom VARCHAR NOT NULL,
    port_nation INT NOT NULL,
    port_continent VARCHAR CHECK (port_continent = 'Europe' OR port_continent = 'Asie' OR port_continent = 'Amérique du Nord' OR port_continent = 'Amérique du Sud' OR port_continent = 'Afrique' OR port_continent = 'Océanie' OR port_continent = 'Antarctique'),
    FOREIGN KEY (port_nation) REFERENCES nation (nation_code),
    port_taille INT NOT NULL CHECK (port_taille >= 1 AND port_taille <= 5)
);

CREATE TABLE navire (
    navire_id INT PRIMARY KEY,
    navire_type VARCHAR CHECK (navire_type = 'Flute' OR navire_type = 'Yacht' OR navire_type = 'Galion' OR navire_type = 'Gabare' OR navire_type = 'Clipper'),
    navire_nation INT NOT NULL,
    navire_capacite_marchandise INT NOT NULL CHECK (navire_capacite_marchandise >= 0),
    navire_capacite_passagers INT NOT NULL CHECK (navire_capacite_passagers >= 0),
    FOREIGN KEY (navire_nation) REFERENCES nation (nation_code),
    CHECK ((navire_capacite_marchandise = 0 AND navire_capacite_passagers > 0) OR (navire_capacite_marchandise > 0 AND navire_capacite_passagers = 0) OR (navire_capacite_marchandise > 0 AND navire_capacite_passagers > 0))
);

CREATE TABLE voyage (
    voyage_id INT PRIMARY KEY,
    voyage_date_depart DATE NOT NULL,
    voyage_date_arrive DATE NOT NULL,
    voyage_navire_id INT NOT NULL,
    voyage_port_depart INT NOT NULL,
    voyage_port_arrivee INT,
    voyage_type VARCHAR NOT NULL CHECK (voyage_type = 'Court' OR voyage_type = 'Moyen' OR voyage_type = 'Long'),
    voyage_continent VARCHAR CHECK (voyage_continent = 'Europe' OR voyage_continent = 'Asie' OR voyage_continent = 'Amérique du Nord' OR voyage_continent = 'Amérique du Sud' OR voyage_continent = 'Afrique' OR voyage_continent = 'Océanie' OR voyage_continent = 'Antarctique' OR voyage_continent = 'Intercontinental'),
    FOREIGN KEY (voyage_navire_id) REFERENCES navire (navire_id),
    FOREIGN KEY (voyage_port_depart) REFERENCES port (port_id),
    FOREIGN KEY (voyage_port_arrivee) REFERENCES port (port_id),
    CHECK (voyage_date_depart < voyage_date_arrive)
);

CREATE TABLE produit (
    produit_id INT PRIMARY KEY,
    produit_nom VARCHAR NOT NULL,
    produit_volume_kg INT NOT NULL CHECK (produit_volume_kg >= 0),
    produit_prix_kg INT,
    produit_perissable BOOLEAN NOT NULL
);

CREATE TABLE etape (
    etape_id SERIAL PRIMARY KEY,
    etape_voyage_id INT NOT NULL,
    etape_numero INT NOT NULL CHECK (etape_numero >= 1),
    etape_port_id INT NOT NULL,
    etape_passagers_delta INT,
    FOREIGN KEY (etape_voyage_id) REFERENCES voyage (voyage_id),
    FOREIGN KEY (etape_port_id) REFERENCES port (port_id),
    UNIQUE (etape_numero, etape_voyage_id)
);

CREATE TABLE cargaison (
    cargaison_etape_id INT NOT NULL,
    cargaison_produit_id INT NOT NULL,
    cargaison_quantite_produit INT NOT NULL,
    FOREIGN KEY (cargaison_etape_id) REFERENCES etape (etape_id),
    FOREIGN KEY (cargaison_produit_id) REFERENCES produit (produit_id),
    PRIMARY KEY (cargaison_etape_id, cargaison_produit_id)
);

CREATE TABLE diplomatie (
    diplomatie_nation_1 INT NOT NULL,
    diplomatie_nation_2 INT NOT NULL,
    diplomatie_relation VARCHAR CHECK (diplomatie_relation = 'Alliés Commerciaux' OR diplomatie_relation = 'Alliés' OR diplomatie_relation = 'Neutres' OR diplomatie_relation = 'En Guerre'),
    FOREIGN KEY (diplomatie_nation_1) REFERENCES nation (nation_code),
    FOREIGN KEY (diplomatie_nation_2) REFERENCES nation (nation_code),
    PRIMARY KEY (diplomatie_nation_1, diplomatie_nation_2)
);

\COPY nation FROM './CSV/nation.csv' CSV;
\COPY produit FROM './CSV/produit.csv' CSV;
\COPY port FROM './CSV/port.csv' CSV;
\COPY navire FROM './CSV/navire.csv' CSV;
\COPY voyage FROM './CSV/voyage.csv' WITH NULL AS 'NULL' CSV;
\COPY diplomatie FROM './CSV/diplomatie.csv' CSV;
\COPY etape FROM './CSV/etape.csv' WITH NULL AS 'NULL' CSV;
\COPY cargaison FROM './CSV/cargaison.csv' CSV;

/**
 1-n + 1-n table de transition
**/