-- Quels ports ont exportés le produit?
SELECT P.port_id, SUM(cargaison_quantite_produit) AS quantite_exportee
FROM port P
JOIN voyage V ON V.voyage_port_depart = P.port_id
JOIN etape E ON E.etape_voyage_id = V.voyage_id
JOIN cargaison C ON C.cargaison_etape_id = E.etape_id
JOIN produit P2 ON P2.produit_id = C.cargaison_produit_id
GROUP BY P.port_id
ORDER BY quantite_exportee DESC
LIMIT 20;