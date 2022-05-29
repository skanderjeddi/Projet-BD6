-- Quelles sont les nations des navires qui ont déjà transporté du rhum?
SELECT N1.nation_nom FROM nation N1
WHERE EXISTS (
    SELECT * FROM 
    JOIN Navire N2 ON Nation.id_nation = Navire.id_nation 
    JOIN Voyage ON Navire.id_navire = Voyage.id_navire 
    JOIN Etape ON Voyage.id_voyage = Etape.id_voyage 
    JOIN Packing ON Etape.id_etape = Packing.id_etape
    JOIN Produit ON Packing.id_produit = Produit.id_produit
    WHERE N2.id_nation = N1.id_nation AND Packing.nom = 'x'
)