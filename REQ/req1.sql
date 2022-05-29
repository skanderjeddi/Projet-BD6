-- Avec quel stock chaque voyage part-il?
SELECT voyage_id, SUM(cargaison_quantite_produit * produit_volume_kg) AS stock
FROM navire JOIN voyage ON navire.navire_id = voyage.voyage_navire_id
JOIN etape ON voyage.voyage_id = etape.etape_voyage_id
JOIN cargaison ON etape.etape_id = cargaison.cargaison_etape_id
JOIN produit ON produit_id = cargaison_produit_id
WHERE etape.etape_numero = 1
GROUP BY voyage_id
ORDER BY stock DESC;