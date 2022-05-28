-- Sous-requête corrélée: Cette requête récupère les navires pouvant transporter le plus de passagers de chaque nation
SELECT N1.id_navire, N1.nation, N1.capacite_passagers
FROM navire N1
WHERE N1.capacite_passagers >=
    (SELECT MAX(N2.capacite_passagers)
    FROM navire N2 
    WHERE N1.nation = N2.nation)
ORDER BY N1.capacite_passagers DESC;