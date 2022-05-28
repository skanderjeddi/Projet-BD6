-- 3 TABLES: Cette requête récupère tous les voyages effectués par des clippers en direction d'Amérique du Nord apres le 11/09/2001
SELECT id_voyage, date_depart, port_depart FROM voyage as V 
JOIN navire ON navire.id_navire = V.id_navire 
JOIN port ON port.id_port = V.port_arrivee
WHERE navire.categorie = 'Clipper' AND port.localisation = 'Amérique du Nord' AND V.date_depart > '2001-09-11'
ORDER BY date_depart ASC;