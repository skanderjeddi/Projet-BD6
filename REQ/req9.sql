-- Cette requête récupère la liste ordonnée des navires ayant transporté le plus de marchandise
SELECT N.navire_id, SUM(cargaison_quantite_produit * produit_volume_kg) AS charge
FROM navire N JOIN voyage V ON N.navire_id = V.voyage_navire_id
JOIN port P on P.port_id = V.voyage_port_depart OR P.port_id = V.voyage_port_arrivee
JOIN etape E ON E.etape_port_id = P.port_id
JOIN cargaison C ON C.cargaison_etape_id = E.etape_id
JOIN produit P2 ON P2.produit_id = C.cargaison_produit_id
GROUP BY N.navire_id
ORDER BY charge DESC;