-- Quels sont les ports des pays en guerre avec l'Angleterre ?

SELECT DISTINCT Port.nom FROM (
    SELECT id_nation1, id_nation2 FROM
        Diplomatie JOIN Nation ON Nation.id_nation = Diplomation.id_nation1 OR Diplomatie.id_nation2 = Nation.id_nation
        WHERE Nation.nom = 'Angleterre'
) 
WHERE (Diplomation.id_nation1 = Nation.id_nation AND Port.id_nation = Diplomation.id_nation2) 
    OR
    (Diplomation.id_nation1 = Nation.id_nation AND Port.id_nation = Diplomation.id_nation2)