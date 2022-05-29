-- Sous-requête dans le WHERE: Cette requête récupère tous les ports qui ont été départ ou destination d'un voyage intercontinental court
SELECT id_port, nation
FROM port
WHERE id_port IN
                (SELECT port_depart
                FROM voyage
                WHERE categorie = 'Europe' AND type_voyage = 'Court'
                UNION
                SELECT port_arrivee
                FROM voyage
                WHERE categorie = 'Europe' AND type_voyage = 'Court')