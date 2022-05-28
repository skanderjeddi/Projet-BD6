-- Sous-requête dans le FROM: Cette requête récupère le nom de toutes les nations qui ont des nations alliées en Océanie
SELECT T.nom_nation
FROM
    (SELECT * FROM nation N1, nation N2, diplomatie D1
    WHERE D1.nation_1 = N1.code_nation
    AND D1.nation_2 = N2.code_nation
    AND N2.
    AND D1.relation_diplomatique = ) T;