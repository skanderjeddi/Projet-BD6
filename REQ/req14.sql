-- Auto jointure: Cette requête récupère tous les voyages différents qui ont les mêmes trajets
SELECT V1.voyage_id, V2.voyage_id, V1.voyage_port_depart, V1.voyage_port_arrivee 
FROM voyage V1 
INNER JOIN voyage V2
ON (V1.voyage_port_depart = V2.voyage_port_depart 
    AND V1.voyage_port_arrivee = V2.voyage_port_arrivee 
    AND V1.voyage_id < V2.voyage_id);