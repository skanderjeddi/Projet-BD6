-- Cette requête récupère les ports qui ne sont jamais destination d'un voyage
SELECT P1.port_id
FROM port P1
WHERE NOT EXISTS (
    SELECT *
    FROM voyage V
    WHERE P1.port_id = V.voyage_port_arrivee
);