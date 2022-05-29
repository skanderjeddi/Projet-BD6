-- Cette requête récupère les noms des nations des navires qui ont déjà transporté du rhum
SELECT N1.nation_nom FROM nation N1
WHERE EXISTS (
    SELECT *
    FROM nation N2 
    JOIN navire N3 ON N2.nation_code = N3.navire_nation 
    JOIN voyage ON N3.navire_id = voyage.voyage_navire_id
    JOIN etape ON voyage.voyage_id = etape.etape_voyage_id 
    JOIN cargaison ON etape.etape_id = cargaison.cargaison_etape_id
    JOIN produit ON cargaison.cargaison_produit_id = produit.produit_id
    WHERE N2.nation_code = N1.nation_code AND produit.produit_nom = 'Rhum'
);