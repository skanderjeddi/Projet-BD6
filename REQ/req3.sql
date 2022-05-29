-- Quels sont les ports des pays en guerre avec la France?
SELECT nation_nom AS en_guerre
FROM (SELECT diplomatie_nation_2
    FROM diplomatie JOIN nation ON nation_code = diplomatie_nation_1
    WHERE nation_nom = 'Russie' AND diplomatie_relation = 'En Guerre'
    UNION
    SELECT diplomatie_nation_1
    FROM diplomatie JOIN nation ON nation_code = diplomatie_nation_2
    WHERE nation_nom = 'Russie' AND diplomatie_relation = 'En Guerre'
    ) AS M
    JOIN nation ON M.diplomatie_nation_2 = nation_code
ORDER BY en_guerre ASC;