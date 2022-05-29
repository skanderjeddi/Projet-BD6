-- Avec quel stock chaque voyage part-il?
SELECT voyage_id, SUM(cargaison_quantite_produit * produit_volume_kg) AS stock
FROM navire
JOIN voyage ON navire.navire_id = voyage.voyage_navire_id
JOIN etape ON voyage.voyage_id = etape.etape_voyage_id
JOIN cargaison ON etape.etape_id = cargaison.cargaison_etape_id
JOIN produit ON produit_id = cargaison_produit_id
WHERE etape.etape_numero = 1
GROUP BY voyage_id
ORDER BY stock DESC;

-- Cette requête récupère les noms des nations des navires qui ont déjà transporté du rhum
SELECT N1.nation_nom FROM nation N1
WHERE EXISTS (
    SELECT *
    FROM nation N2 
    JOIN navire N3 ON N2.nation_code = N3.navire_nation 
    JOIN voyage ON N3.navire_id = voyage.voyage_navire_id
    JOIN etape ON voyage.voyage_id = etape.etape_voyage_id 
    JOIN cargaison ON etape.etape_id = cargaison.cargaison_etape_id
    JOIN produit ON cargaison.cargaison_produit_id = produit.produit_id
    WHERE N2.nation_code = N1.nation_code AND produit.produit_nom = 'Rhum'
);

-- Cette requête récupère les noms des pays en guerre avec la France?
SELECT nation_nom AS en_guerre
FROM (SELECT diplomatie_nation_2
    FROM diplomatie 
    JOIN nation ON nation_code = diplomatie_nation_1
    WHERE nation_nom = 'France' AND diplomatie_relation = 'En Guerre'
    UNION
    SELECT diplomatie_nation_1
    FROM diplomatie
    JOIN nation ON nation_code = diplomatie_nation_2
    WHERE nation_nom = 'France' AND diplomatie_relation = 'En Guerre'
    ) AS M
    JOIN nation ON M.diplomatie_nation_2 = nation_code
ORDER BY en_guerre ASC;

-- Cette requête récupère le produit le plus exporté entre 2000 et 2010
SELECT produit_nom, SUM(cargaison_quantite_produit) AS quantite_exportee
FROM produit P
JOIN cargaison C ON P.produit_id = C.cargaison_produit_id
JOIN etape E ON E.etape_id = C.cargaison_etape_id
JOIN voyage V ON V.voyage_id = E.etape_voyage_id
WHERE V.voyage_date_depart >= '2000-01-01' AND V.voyage_date_arrive < '2010-01-01'
GROUP BY P.produit_id
ORDER BY quantite_exportee DESC
LIMIT 1;

-- Cette requête récupère les ports qui ne sont jamais destination d'un voyage
SELECT P1.port_id
FROM port P1
WHERE NOT EXISTS (
    SELECT *
    FROM voyage V
    WHERE P1.port_id = V.voyage_port_arrivee
);

-- Quels ports ont exportés le produit?
SELECT P.port_id, SUM(cargaison_quantite_produit) AS quantite_exportee
FROM port P
JOIN voyage V ON V.voyage_port_depart = P.port_id
JOIN etape E ON E.etape_voyage_id = V.voyage_id
JOIN cargaison C ON C.cargaison_etape_id = E.etape_id
JOIN produit P2 ON P2.produit_id = C.cargaison_produit_id
GROUP BY P.port_id
ORDER BY quantite_exportee DESC
LIMIT 20;

-- Jointure externe (FULL JOIN): Cette requête récupère les voyages et étapes ayant les ports (d'arrivée pour le voyage) en commun
SELECT V.voyage_id, E.etape_id, E.etape_passagers_delta
FROM etape E
FULL JOIN voyage V ON E.etape_port_id = V.voyage_port_arrivee;

-- Condition de totalité (requêtes corrélées + agrégats): Cette requête récupère les navires et leurs nations correspondantes ayant effectué plus de voyages que tous les autres
SELECT * FROM (SELECT N1.navire_id, N1.navire_nation, COUNT(V1.voyage_id) AS voyages
                        FROM navire N1
                        JOIN voyage V1 ON N1.navire_id = V1.voyage_navire_id 
                        GROUP BY N1.navire_id) C1 
                        WHERE voyages >= ALL (SELECT COUNT(V2.voyage_id) AS C2
                                        FROM navire N2 JOIN voyage V2 ON N2.navire_id = V2.voyage_navire_id
                                        GROUP BY N2.navire_id)
ORDER BY navire_id ASC;

-- Cette requête récupère la liste ordonnée des navires ayant transporté le plus de marchandise
SELECT N.navire_id, SUM(cargaison_quantite_produit * produit_volume_kg) AS charge
FROM navire N JOIN voyage V ON N.navire_id = V.voyage_navire_id
JOIN port P on P.port_id = V.voyage_port_depart OR P.port_id = V.voyage_port_arrivee
JOIN etape E ON E.etape_port_id = P.port_id
JOIN cargaison C ON C.cargaison_etape_id = E.etape_id
JOIN produit P2 ON P2.produit_id = C.cargaison_produit_id
GROUP BY N.navire_id
ORDER BY charge DESC;

-- Cette requête renvoie tous les ports de taille impaire situés en Asie
SELECT nation_nom, port_id, port_taille
FROM nation N INNER JOIN port P ON P.port_nation = N.nation_code
WHERE P.port_taille IN (1, 3, 5) AND P.port_continent = 'Asie';

-- Sous-requête dans le WHERE: Cette requête récupère tous les ports qui ont été départ ou destination d'un voyage intercontinental court
SELECT port_id, port_nation
FROM port
WHERE port_id IN
                (SELECT voyage_port_depart
                FROM voyage
                WHERE voyage_continent = 'Europe' AND voyage_type = 'Court'
                UNION
                SELECT voyage_port_depart
                FROM voyage
                WHERE voyage_continent = 'Europe' AND voyage_type = 'Court');

-- Sous-requête dans le FROM: Cette requête récupère la liste des voyages ayant 3 étapes et les ports ayant servi comme 3ème étape
SELECT DISTINCT T.etape_voyage_id, T.etape_port_id
FROM (SELECT *
    FROM etape 
    WHERE etape_numero = 3) AS T
JOIN voyage V ON T.etape_voyage_id = V.voyage_id
ORDER BY T.etape_voyage_id ASC;

-- Sous-requête corrélée: Cette requête récupère les navires pouvant transporter le plus de passagers de chaque nation
SELECT N1.navire_id, N1.navire_nation, N1.navire_capacite_passagers
FROM navire N1
WHERE N1.navire_capacite_passagers >=
    (SELECT MAX(N2.navire_capacite_passagers)
    FROM navire N2 
    WHERE N1.navire_nation = N2.navire_nation)
ORDER BY N1.navire_capacite_passagers DESC;

-- Auto jointure: Cette requête récupère tous les voyages différents qui ont les mêmes trajets
SELECT V1.voyage_id, V2.voyage_id, V1.voyage_port_depart, V1.voyage_port_arrivee 
FROM voyage V1 
INNER JOIN voyage V2
ON (V1.voyage_port_depart = V2.voyage_port_depart 
    AND V1.voyage_port_arrivee = V2.voyage_port_arrivee 
    AND V1.voyage_id < V2.voyage_id);

-- 3 TABLES: Cette requête récupère tous les voyages effectués par des clippers en direction d'Amérique du Nord entre 2001 et 2002
SELECT V.voyage_id, V.voyage_date_depart, V.voyage_port_depart
FROM voyage as V 
JOIN navire ON navire.navire_id = V.voyage_navire_id 
JOIN port ON port.port_id = V.voyage_port_arrivee
WHERE navire.navire_type = 'Clipper' AND port.port_continent = 'Amérique du Nord' AND V.voyage_date_depart > '2001-01-01' AND V.voyage_date_depart < '2002-01-01'
ORDER BY V.voyage_date_depart ASC;

-- Deux agrégats nécessitant GROUP BY et HAVING: Cette requête récupère les nations ayant plus que 20 navires
SELECT navire_nation, COUNT(navire_id) AS navires
FROM navire
GROUP BY navire_nation
HAVING COUNT(navire_id) > 20
ORDER BY COUNT(navire_id) DESC;

-- Cette requête récupère les produits qui ont un prix supérieur à la moyenne des prix de tous les produits
SELECT produit_nom, produit_prix_kg
FROM produit
WHERE produit_prix_kg > (
    SELECT AVG(produit_prix_kg)
    FROM produit
);

-- Cette requête renvoie la liste des pays ayant le plus d'ennemis dans l'ordre décroissant
SELECT N.nation_nom, COUNT(diplomatie_nation_1) as ennemis
FROM nation N JOIN diplomatie D ON N.nation_code = D.diplomatie_nation_1 OR N.nation_code = D.diplomatie_nation_2
WHERE D.diplomatie_relation = 'En Guerre'
GROUP BY N.nation_code
ORDER BY ennemis DESC;



-- Requête récursive
WITH RECURSIVE access(depart, arrivee) AS
(
SELECT voyage_port_depart, voyage_port_arrivee FROM voyage
UNION
SELECT V.voyage_port_depart, A.arrivee
FROM voyage V, access A
WHERE V.voyage_port_arrivee = A.depart
)
SELECT * FROM access
LIMIT 35;