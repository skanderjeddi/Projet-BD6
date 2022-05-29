-- Sous-requête dans le WHERE: Cette requête récupère tous les ports qui ont été départ ou destination d'un voyage intercontinental court
SELECT port_id, port_nation
FROM port
WHERE port_id IN
                (SELECT voyage_port_depart
                FROM voyage
                WHERE voyage_continent = 'Europe' AND voyage_type = 'Court'
                UNION
                SELECT voyage_port_depart
                FROM voyage
                WHERE voyage_continent = 'Europe' AND voyage_type = 'Court');