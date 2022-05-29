-- Sous-requête dans le FROM: Cette requête récupère la liste des voyages ayant 3 étapes et les ports ayant servi comme 3ème étape
SELECT DISTINCT T.etape_voyage_id, T.etape_port_id
FROM (SELECT *
    FROM etape 
    WHERE etape_numero = 3) AS T
JOIN voyage V ON T.etape_voyage_id = V.voyage_id
ORDER BY T.etape_voyage_id ASC;