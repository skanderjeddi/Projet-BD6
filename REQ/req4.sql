-- Cette requête récupère le produit le plus exporté entre 2000 et 2010
SELECT produit_nom, SUM(cargaison_quantite_produit) AS quantite_exportee
FROM produit P
JOIN cargaison C ON P.produit_id = C.cargaison_produit_id
JOIN etape E ON E.etape_id = C.cargaison_etape_id
JOIN voyage V ON V.voyage_id = E.etape_voyage_id
WHERE V.voyage_date_depart >= '2000-01-01' AND V.voyage_date_arrive < '2010-01-01'
GROUP BY P.produit_id
ORDER BY quantite_exportee DESC
LIMIT 1;