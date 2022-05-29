-- Requête récursive
WITH RECURSIVE access(depart, arrivee) AS
(
SELECT voyage_port_depart, voyage_port_arrivee FROM voyage
UNION
SELECT V.voyage_port_depart, A.arrivee
FROM voyage V, access A
WHERE V.voyage_port_arrivee = A.depart
)
SELECT * FROM access
LIMIT 35;