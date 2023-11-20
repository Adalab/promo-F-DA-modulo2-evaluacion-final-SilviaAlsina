USE `sakila`;
/*NOTA:
LOS COMENTARIOS AL LADO DE LOS SELECT SON COMPROBACIONES, NO PARTE DE LA QUERIE FINAL*/

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT `title` AS `Título`
FROM `film`;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT `title` AS `Título`-- , `rating` AS `Clasificación`
FROM `film`
WHERE `rating`='PG-13';

-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT `title` AS `Título`, `description` AS `Descripción`
FROM `film`
WHERE `description` LIKE '% amazing %';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT `title` AS `Título`-- , `length` AS `Duración`
FROM `film`
WHERE `length`>120;

-- 5. Recupera los nombres de todos los actores.
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor`
FROM `actor`;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor`
FROM `actor`
WHERE `last_name`='Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor`-- , `actor_id` AS `ActorID`
FROM `actor`
WHERE `actor_id`>=10 AND `actor_id`<=20 ;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT `title` AS `Título`-- , `rating` AS `Clasificación`
FROM `film`
WHERE `rating`<>'PG-13' AND `rating`<>'R';

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT `rating` AS `ClasificaciónPorEdades`,COUNT(`rating`) AS `CantidadPelículas`
FROM `film`
GROUP BY `rating`;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la 
cantidad de películas alquiladas.*/
SELECT `c`.`customer_id` AS `IDCliente`, CONCAT(`c`.`first_name`,' ',`c`.`last_name`) AS `NombreCliente`, COUNT(`r`.`inventory_id`) AS `CantidadPelículasAlquiladas`
FROM `customer` AS `c`
INNER JOIN `rental` AS `r`
ON `c`.`customer_id`=`r`.`customer_id`
GROUP BY `r`.`customer_id`;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de
 alquileres.*/
 SELECT `c`.`name` AS `NombreCategoría`,COUNT(`fc`.`film_id`) AS `RecuentoAlquileres`
 FROM `film_category` AS `fc`
 INNER JOIN `category` AS `c`
 ON `fc`.`category_id`=`c`.`category_id`
 WHERE `fc`.`film_id` IN (
	SELECT `film_id`
	FROM `inventory`
    WHERE `inventory_id` IN(
		SELECT `inventory_id`
        FROM `rental`))
GROUP BY `c`.`category_id`;
    
/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.*/
SELECT `rating` AS `Clasificación`, AVG(`length`) AS `DuraciónMedia`
FROM `film`
GROUP BY `Clasificación`;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor` 
FROM `actor`
WHERE `actor_id` IN (
	SELECT `actor_id`
    FROM `film_actor`
    WHERE `film_id` IN (
		SELECT `film_id`
        FROM `film`
        WHERE `title`='Indian Love'));
        
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT `title` AS `Título`, `description` AS `Descripción`
FROM `film`
WHERE `description` LIKE '% cat %' OR `description` LIKE '% dog %';
-- 15. Hay algún actor que no aparecen en ninguna película en la tabla film_actor.
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor`
FROM `actor`
WHERE `actor_id` NOT IN (
	SELECT `actor_id`
    FROM `film_actor`);
-- No hay ningún actor que no aparezca en ninguna película de la tabla film_actor

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT `title` AS `Título`-- , `release_year`
FROM `film`
WHERE `release_year`>=2005 AND `release_year`<=2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT `title` AS `Título`
FROM `film`
WHERE `film_id` IN (SELECT `film_id`
FROM `film_category`
WHERE `category_id` IN 
	(SELECT `category_id`
	FROM `category`
	WHERE `name`='Family'));
    
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
WITH `actores_condicion` AS(SELECT `actor_id`
FROM `film_actor`
GROUP BY `actor_id`
HAVING COUNT(DISTINCT `film_id`)>10)

SELECT CONCAT(`a`.`first_name`,' ',`a`.`last_name`) AS `NombreActor`
FROM `actor` AS `a`
NATURAL JOIN `actores_condicion` AS `ac`;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT `title` AS `Título`-- , `length`, `rating`
FROM `film`
WHERE `length`>120 AND `rating`='R';

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.*/          
SELECT `c`.`name` AS `NombreCategoría`, AVG(`f`.`length`) AS `DuraciónMedia`
FROM `category` AS `c`
INNER JOIN `film_category` AS `fc`
ON `c`.`category_id`=`fc`.`category_id`
INNER JOIN `film` AS `f`
ON `f`.`film_id`=`fc`.`film_id`
GROUP BY `c`.`category_id`
HAVING AVG(`f`.`length`)>120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las 
que han actuado.*/
WITH `actores_condicion` AS(SELECT `actor_id`, COUNT(DISTINCT `film_id`) AS `CantidadPelículas`
FROM `film_actor`
GROUP BY `actor_id`
HAVING COUNT(DISTINCT `film_id`)>=5)

SELECT CONCAT(`a`.`first_name`,' ',`a`.`last_name`) AS `NombreActor`, `ac`.`CantidadPelículas`
FROM `actor` AS `a`
NATURAL JOIN `actores_condicion` AS `ac`;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los 
rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/
SELECT `title` AS `Título`
FROM `film`
WHERE `film_id` IN (
	SELECT `film_id`
	FROM `inventory`
	WHERE `inventory_id` IN (
		SELECT `inventory_id`
		FROM `rental`
		WHERE DATEDIFF(`return_date`,`rental_date`)>5));

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta
 para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
SELECT CONCAT(`first_name`,' ',`last_name`) AS `NombreActor`
FROM `actor`
WHERE `actor_id` NOT IN (
	 SELECT `actor_id`
	 FROM `film_actor`
	 WHERE`film_id` IN (
		 SELECT `film_id`
		 FROM `film_category`
		 WHERE `category_id` IN (
			 SELECT `category_id`
			 FROM `category`
			 WHERE `name`='Horror')));
 
-- BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT `f`.`title` AS `Título`-- , `f`.`length` AS `Duración`,`c`.`name` 
FROM `category` AS `c`
INNER JOIN `film_category` AS `fc`
ON `c`.`category_id`=`fc`.`category_id`
INNER JOIN `film` AS `f`
ON `f`.`film_id`=`fc`.`film_id`
WHERE `f`.`length`>180 AND `c`.`name`='Comedy';

/* BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los 
actores y el número de películas en las que han actuado juntos.*/
WITH `pelis_actor1`AS (
					WITH `actor_nombre1` AS (SELECT CONCAT(`first_name`,' ',`last_name`) AS 'NombreActor', `actor_id`
					FROM `actor`),
					`pelis` AS(SELECT `fa`.`film_id` AS 'PelisActuadas',`fa`.`actor_id`
					FROM `film_actor` AS `fa`)
					SELECT `a1`.`NombreActor`, `p`.`PelisActuadas`
					FROM `pelis` AS `p`
					INNER JOIN `actor_nombre1` AS `a1`
					ON `p`.`actor_id`=`a1`.`actor_id`),
`pelis_actor2`AS (
					WITH `actor_nombre2` AS (SELECT CONCAT(`first_name`,' ',`last_name`) AS 'NombreActor', `actor_id`
					FROM `actor`),
					`pelis` AS(SELECT `fa`.`film_id` AS 'PelisActuadas',`fa`.`actor_id`
					FROM `film_actor` AS `fa`)
					SELECT `a2`.`NombreActor`, `p`.`PelisActuadas`
					FROM `pelis` AS `p`
					INNER JOIN `actor_nombre2` AS `a2`
					ON `p`.`actor_id`=`a2`.`actor_id`)
SELECT `p1`.`NombreActor`,`p2`.`NombreActor`, COUNT(DISTINCT `p1`.`PelisActuadas`) AS 'PelículasJuntos'
FROM `pelis_actor1` AS `p1`
INNER JOIN `pelis_actor2` AS `p2`
ON `p2`.`PelisActuadas`=`p1`.`PelisActuadas`
GROUP BY `p1`.`NombreActor`,`p2`.`NombreActor`
HAVING `p1`.`NombreActor`<>`p2`.`NombreActor`    