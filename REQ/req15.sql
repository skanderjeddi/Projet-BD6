-- 3 TABLES: Cette requête récupère tous les voyages effectués par des clippers en direction d'Amérique du Nord entre 2001 et 2002
SELECT V.voyage_id, V.voyage_date_depart, V.voyage_port_depart
FROM voyage as V 
JOIN navire ON navire.navire_id = V.voyage_navire_id 
JOIN port ON port.port_id = V.voyage_port_arrivee
WHERE navire.navire_type = 'Clipper' AND port.port_continent = 'Amérique du Nord' AND V.voyage_date_depart > '2001-01-01' AND V.voyage_date_depart < '2002-01-01'
ORDER BY V.voyage_date_depart ASC;