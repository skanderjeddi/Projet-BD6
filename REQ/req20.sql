-- Requête récursive
WITH RECURSIVE access(depart, arrivee) AS
(
SELECT port_depart, port_arrivee FROM voyage
UNION
SELECT V.port_depart, A.arrivee
FROM voyage V, access A
WHERE V.port_arrivee = A.depart
)
SELECT * FROM access
LIMIT 35;