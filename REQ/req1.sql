-- avec quel stock le navire x entame-t-il ses voyages ?

SELECT Voyage.id_voyage, Produit.nom, Packing.quantite FROM 
    Navire JOIN Voyage ON Navire.id_navire = Voyage.id_navire JOIN Etape ON Voyage.id_voyage = Etape.id_voyage JOIN Packing ON Etape.id_etape = Packing.id_etape
WHERE Navire.nom = 'x' AND Etape.numero = 1
