-- Condition de totalité (requêtes corrélées + agrégats): Cette requête récupère les navires et leurs nations correspondantes ayant effectué plus de voyages que tous les autres
SELECT * FROM (SELECT N1.navire_id, N1.navire_nation, COUNT(V1.voyage_id) AS voyages
                        FROM navire N1
                        JOIN voyage V1 ON N1.navire_id = V1.voyage_navire_id 
                        GROUP BY N1.navire_id) C1 
                        WHERE voyages >= ALL (SELECT COUNT(V2.voyage_id) AS C2
                                        FROM navire N2 JOIN voyage V2 ON N2.navire_id = V2.voyage_navire_id
                                        GROUP BY N2.navire_id)
ORDER BY navire_id ASC;