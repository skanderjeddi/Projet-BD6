-- Cette requête renvoie la liste des pays ayant le plus d'ennemis dans l'ordre décroissant
SELECT N.nation_nom, COUNT(diplomatie_nation_1) as ennemis
FROM nation N JOIN diplomatie D ON N.nation_code = D.diplomatie_nation_1 OR N.nation_code = D.diplomatie_nation_2
WHERE D.diplomatie_relation = 'En Guerre'
GROUP BY N.nation_code
ORDER BY ennemis DESC;