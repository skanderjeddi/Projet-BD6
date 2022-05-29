-- Quel est le trajet du navire x ?
SELECT *
    FROM diplomatie JOIN nation ON nation_code = diplomatie_nation_1 OR diplomatie_nation_2 = nation_code
    WHERE nation_nom = 'France' AND diplomatie_relation = 'En Guerre';