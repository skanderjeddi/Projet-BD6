-- Auto jointure: Cette requête récupère tous les voyages différents qui ont les mêmes trajets
SELECT V1.id_voyage, V2.id_voyage, V1.port_depart, V1.port_arrivee FROM voyage V1 INNER JOIN voyage V2
ON (V1.port_depart = V2.port_depart 
    AND V1.port_arrivee = V2.port_arrivee 
    AND V1.id_voyage < V2.id_voyage);