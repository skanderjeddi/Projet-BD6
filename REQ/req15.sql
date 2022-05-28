-- 3 TABLES: Cette requête récupère tous les voyages effectués par des clippers en direction d'Amérique du Nord entre 2001 et 2002
SELECT id_voyage, date_depart, port_depart
FROM voyage as V 
JOIN navire ON navire.id_navire = V.id_navire 
JOIN port ON port.id_port = V.port_arrivee
WHERE navire.categorie = 'Clipper' AND port.localisation = 'Amérique du Nord' AND V.date_depart > '2001-01-01' AND V.date_depart < '2002-01-01'
ORDER BY date_depart ASC;