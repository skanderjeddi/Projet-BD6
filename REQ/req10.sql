-- Cette requête renvoie tous les ports de taille impaire situés en Asie
SELECT nation_nom, port_id, port_taille
FROM nation N INNER JOIN port P ON P.port_nation = N.nation_code
WHERE P.port_taille IN (1, 3, 5) AND P.port_continent = 'Asie';