--1 Afficher toutes les recettes disponibles (nom de la recette, catégorie et temps de préparation) triées de façon décroissante sur la durée de réalisation


SELECT nom_recette, temps_preparation, categorie.nom_categorie
FROM recette
INNER JOIN categorie ON recette.id_categorie = categorie.id_categorie
ORDER BY temps_preparation

--2 En modifiant la requête précédente, faites apparaître le nombre d’ingrédients nécessaire par recette.

SELECT nom_recette, temps_preparation, categorie.nom_categorie, COUNT(ingredient_recette.id_recette) AS nbIngredient
FROM recette
LEFT JOIN ingredient_recette ON recette.id_recette= ingredient_recette.id_recette
INNER JOIN categorie ON recette.id_categorie = categorie.id_categorie
GROUP BY recette.id_recette
ORDER BY nbIngredient DESC

--3 Afficher les recettes qui nécessitent au moins 30 min de préparation
SELECT nom_recette,temp_de_preparation
FROM recette 
WHERE temp_de_preparation>=30
ORDER BY temp_de_preparation

--4 Afficher les recettes dont le nom contient le mot « Salade » (peu importe où est situé le mot en question)
SELECT nom_recette
FROM recette
WHERE LOWER(nom_recette) LIKE '%salade%'
ORDER BY nom_recette

--5 Insérer une nouvelle recette : « Pâtes Bolo » dont la durée de réalisation est de 20 min avec les instructions de votre choix. 
--Pensez à alimenter votre base de données en conséquence afin de pouvoir lister les détails de cette recettes (ingrédients)
INSERT INTO recette (nom_recette, temp_de_preparation, instructions, id_categorie)
VALUES ('Salade César', 20, 'Mélanger la laitue, le poulet, les croûtons, le parmesan et la sauce César. Servir frais.', 2);

--6 Modifier le nom de la recette ayant comme identifiant id_recette = 3 (nom de la recette à votre convenance)
UPDATE recette
SET nom_recette = 'Soupe Miso'
WHERE id_recette = 3

--7 Supprimer la recette n°12 de la base de données
DELETE FROM ingredient_recette
WHERE ingredient_recette.id_ingredient=7
--APRES
DELETE FROM recette
WHERE id.recette=7   

--8 Afficher le prix total de la recette n°9
SELECT SUM(prix*ingredient_recette.qunatite) AS total,nom_recette
FROM ingredients 
INNER JOIN ingredient_recette ON ingredients.id_ingredient = ingredient_recette.id_ingredient
INNER JOIN recette ON ingredient_recette.id_recette = recette.id_recette
WHERE ingredient_recette.id_recette=9

--9 Afficher le détail de la recette n°14 (liste des ingrédients, quantités et prix)
SELECT nom_ingredient, ingredient_recette.qunatite, prix
FROM ingredients
INNER JOIN ingredient_recette ON ingredients.id_ingredient = ingredient_recette.id_ingredient
INNER JOIN recette ON ingredient_recette.id_recette = recette.id_recette
WHERE ingredient_recette.id_recette=14

--10 Ajouter un ingrédient en base de données : Poivre, unité : cuillère à café, prix : 2.5 €
INSERT INTO ingredients (nom_ingredient, unité, prix)
VALUES ('Paprika','cuillere a cafe',2.5)

--11 Modifier le prix de l’ingrédient n°12 (prix à votre convenance)
UPDATE ingredients
SET prix = 5
WHERE id_ingredient=7

--12 Afficher le nombre de recettes par catégories : X entrées, Y plats, Z desserts
SELECT categorie.nom_categorie, COUNT(recette.id_categorie) AS IdCount
FROM categorie 
INNER JOIN recette ON recette.id_categorie = categorie.id_categorie
GROUP BY categorie.id_categorie;

--13 Afficher les recettes qui contiennent l’ingrédient « Poulet »
SELECT  recette.nom_recette
FROM recette
INNER JOIN ingredient_recette ON recette.id_recette = ingredient_recette.id_recette
INNER JOIN ingredients ON ingredient_recette.id_ingredient = ingredients.id_ingredient
WHERE ingredients.nom_ingredient = 'Poulet';

--14 Mettez à jour toutes les recettes en diminuant leur temps de préparation de 5 minutes
UPDATE recette
SET temps_preparation = temps_preparation - 5;

--15 Afficher les recettes qui ne nécessitent pas d’ingrédients coûtant plus de 2€ par unité de mesure
SELECT DISTINCT recette.nom_recette
FROM recette
JOIN ingredient_recette ON recette.id_recette = ingredient_recette.id_recette
JOIN ingredients ON ingredient_recette.id_ingredient = ingredients.id_ingredient
WHERE ingredients.prix <= 2 

--16 Afficher la / les recette(s) les plus rapides à préparer
SELECT nom_recette
FROM recette
WHERE temps_preparation = (
    SELECT MIN(temps_preparation)
    FROM recette
);
--17 Trouver les recettes qui ne nécessitent aucun ingrédient (par exemple la recette de la tasse d’eau chaude qui consiste à verser de l’eau chaude dans une tasse)
SELECT recette.nom_recette, ingredient_recette.id_ingredient
FROM recette
left JOIN ingredient_recette ON ingredient_recette.id_recette = recette.id_recette
left JOIN ingredients ON ingredient_recette.id_ingredient = ingredients.id_ingredient
WHERE ingredient_recette.id_ingredient IS NULL 	

--18 Trouver les ingrédients qui sont utilisés dans au moins 3 recettes
SELECT ingredients.nom_ingredient, COUNT(ingredients.id_ingredient) AS nbIngredients 
FROM ingredients 
inner JOIN ingredient_recette ON ingredient_recette.id_ingredient = ingredients.id_ingredient
GROUP BY ingredients.nom_ingredient
HAVING COUNT(ingredients.id_ingredient) >= 3;

--19 Ajouter un nouvel ingrédient à une recette spécifique
INSERT INTO ingredient_recette (quantite,id_ingredient, id_recette)
VALUES (1,6,14)

--20 Bonus : Trouver la recette la plus coûteuse de la base de données (il peut y avoir des ex aequo, il est donc exclu d’utiliser la clause LIMIT)
SELECT nom_recette, prixTotal  
FROM 
		(SELECT recette.nom_recette, SUM(ingredients.prix) AS prixTotal
		FROM recette	
		INNER JOIN ingredient_recette ON recette.id_recette = ingredient_recette.id_recette
		INNER JOIN ingredients ON ingredients.id_ingredient = ingredient_recette.id_ingredient
		GROUP BY recette.nom_recette) 
		AS prixTotalParRecette

WHERE prixTotal=( SELECT MAX(prixTotal) 
						FROM (SELECT SUM(ingredients.prix) AS prixTotal
								FROM recette
								INNER JOIN ingredient_recette ON recette.id_recette = ingredient_recette.id_recette
								INNER JOIN ingredients ON ingredients.id_ingredient = ingredient_recette.id_ingredient
								GROUP BY recette.nom_recette) 
								AS prixMax);
							