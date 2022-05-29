-- Sous-requête dans le FROM: Cette requête récupère la liste des voyages ayant 3 étapes et les ports ayant servi comme 3ème étape
SELECT DISTINCT T.id_voyage, T.id_port
FROM (SELECT *
    FROM etape 
    WHERE numero = 3) AS T
JOIN voyage V ON T.id_voyage = V.id_voyage
ORDER BY T.id_voyage ASC;