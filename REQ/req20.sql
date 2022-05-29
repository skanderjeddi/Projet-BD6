-- Requête récursive
WITH RECURSIVE Access(depart, arrivee) AS
(
SELECT port_depart, port_arrivee FROM voyage
UNION
SELECT V.port_depart, A.arrivee
FROM voyage V, Access A
WHERE V.port_arrivee = A.depart
)
SELECT * FROM Access
LIMIT 35;