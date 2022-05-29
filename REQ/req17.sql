-- Cette requête récupère les produits qui ont un prix supérieur à la moyenne des prix de tous les produits
SELECT produit_nom, produit_prix_kg
FROM produit
WHERE produit_prix_kg > (
    SELECT AVG(produit_prix_kg)
    FROM produit
)