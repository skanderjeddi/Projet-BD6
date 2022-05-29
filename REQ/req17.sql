--Avoir les produits tel que leur prix total au kilo est inferieru à la moitie de la valeur maximal du tout les produits
SELECT nom, SUM(volume_kg)
FROM produit
GROUP BY nom
HAVING AVG(volume_kg) < 0