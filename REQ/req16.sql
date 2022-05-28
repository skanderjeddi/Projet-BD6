-- Deux agrégats nécessitant GROUP BY et HAVING: Cette requête récupère les nations ayant plus que 20 navires
SELECT nation, COUNT(id_navire)
FROM navire
GROUP BY nation
HAVING COUNT(id_navire) > 20
ORDER BY COUNT(id_navire) DESC;
