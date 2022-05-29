-- Sous-requête corrélée: Cette requête récupère les navires pouvant transporter le plus de passagers de chaque nation
SELECT N1.navire_id, N1.navire_nation, N1.navire_capacite_passagers
FROM navire N1
WHERE N1.navire_capacite_passagers >=
    (SELECT MAX(N2.navire_capacite_passagers)
    FROM navire N2 
    WHERE N1.navire_nation = N2.navire_nation)
ORDER BY N1.navire_capacite_passagers DESC;