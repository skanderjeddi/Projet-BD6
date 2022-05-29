-- Deux agrégats nécessitant GROUP BY et HAVING: Cette requête récupère les nations ayant plus que 20 navires
SELECT navire_nation, COUNT(navire_id) AS navires
FROM navire
GROUP BY navire_nation
HAVING COUNT(navire_id) > 20
ORDER BY COUNT(navire_id) DESC;
