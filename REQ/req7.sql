-- Jointure externe (FULL JOIN): Cette requête récupère les voyages et étapes ayant les ports (d'arrivée pour le voyage) en commun
SELECT V.voyage_id, E.etape_id, E.etape_passagers_delta
FROM etape E
FULL JOIN voyage V ON E.etape_port_id = V.voyage_port_arrivee