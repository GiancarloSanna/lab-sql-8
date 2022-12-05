USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id AS store, city, country
FROM store s
JOIN address
USING(address_id)
JOIN city c
USING (city_id)
JOIN country co
USING(country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT store_id, SUM(p.amount) AS revenue
FROM store s
JOIN customer c
USING(store_id)
JOIN payment p
USING(customer_id)
GROUP BY s.store_id;

-- 3. Which film categories are longest?

-- I understand the question that we try to know which categories have by average the longest films.

SELECT c.name AS category, AVG(f.length) AS average_length
FROM film f
JOIN film_category fc
USING(film_id)
JOIN category c
USING(category_id)
GROUP BY category_id
ORDER BY average_length DESC
LIMIT 5;

-- 4. Display the most frequently rented movies in descending order.

SELECT f.title AS movie, COUNT(r.rental_id) AS rentals
FROM film f
JOIN inventory i
USING(film_id)
JOIN rental r
USING(inventory_id)
GROUP BY f.film_id
ORDER BY rentals DESC 
LIMIT 5;

-- 5. List the top five genres in gross revenue in descending order.

SELECT c.name AS category, SUM(p.amount) AS gross_revenue
FROM category c
JOIN film_category
USING(category_id)
JOIN film
USING(film_id)
JOIN inventory
USING(film_id)
JOIN rental
USING(inventory_id)
JOIN payment p
USING(rental_id)
GROUP BY category_id
ORDER BY gross_revenue DESC
LIMIT 5;


-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT i.store_id AS store, f.title AS movie, COUNT(i.film_id) AS copies_available
FROM inventory i
JOIN film f 
USING(film_id)
WHERE  store_id = 1 AND f.title LIKE 'Academy Dinosaur';

-- There are 4 copies of Academy Dinosaur in store 1


-- 7. Get all pairs of actors that worked together.

SELECT DISTINCT concat(a1.first_name," ",a1.last_name) AS actor1, concat(a2.first_name," ",a2.last_name) AS actor2
FROM film_actor fa1
JOIN film_actor fa2
ON (fa1.actor_id > fa2.actor_id) AND (fa1.film_id = fa2.film_id)
JOIN actor a1
ON fa1.actor_id = a1.actor_id
JOIN actor a2
ON fa2.actor_id = a2.actor_id;


-- 8. Get all pairs of customers that have rented the same film more than 3 times.

-- We create a temporary table to enter the film_id into the rentals.

CREATE TEMPORARY TABLE t1 AS (
SELECT i.film_id, r.rental_id, r.customer_id, r.inventory_id
FROM rental r
JOIN inventory i
USING(inventory_id));
-- We have to create it twice because the self-join doesn't work on the temporary table.
CREATE TEMPORARY TABLE t2 AS (
SELECT i.film_id, r.rental_id, r.customer_id, r.inventory_id
FROM rental r
JOIN inventory i
USING(inventory_id));

-- Solution for same copy of film (rental_id)
SELECT count(t1.film_id) AS number_of_films, 
concat(c1.first_name, " ",c1.last_name) AS customer1,
concat(c2.first_name, " ",c2.last_name) AS customer2
FROM t1
JOIN t2
ON t1.inventory_id = t2.inventory_id AND t1.customer_id > t2.customer_id
JOIN customer c1
ON c1.customer_id = t1.customer_id
JOIN customer c2
ON c2.customer_id = t2.customer_id
GROUP BY t1.customer_id, t2.customer_id
HAVING count(t1.film_id) > 3;

-- Solution for same type of film (film_id)
SELECT count(t1.film_id) AS number_of_films, 
concat(c1.first_name, " ",c1.last_name) AS customer1,
concat(c2.first_name, " ",c2.last_name) AS customer2
FROM t1
JOIN t2
ON t1.film_id = t2.film_id AND t1.customer_id > t2.customer_id
JOIN customer c1
ON c1.customer_id = t1.customer_id
JOIN customer c2
ON c2.customer_id = t2.customer_id
GROUP BY t1.customer_id, t2.customer_id
HAVING count(t1.film_id) > 3;

-- 9. For each film, list actor that has acted in more films.

-- I understand the question, that we have to list for every film,
-- the actor who acted in most films.
DROP TEMPORARY TABLE ta2;
-- Check how many times each actor has acted in movies
CREATE TEMPORARY TABLE ta1 AS(
SELECT actor_id, count(film_id) AS acted
FROM film_actor
GROUP BY actor_id
);
-- Check for each film what was the most times one of the actor has starred in films
CREATE TEMPORARY TABLE ta2 AS(
SELECT fa.film_id, max(ta1.acted) AS max_act
	FROM film_actor fa
	JOIN ta1
	USING(actor_id)
	GROUP BY film_id
	ORDER BY film_id
);

-- Checking results
select * from ta1;
select * from ta2;


-- Joining the results with the film_actor table, getting the rows where the times
-- acted and the maximum times acted are equal
SELECT f.title, concat(a.first_name, " ",a.last_name) AS most_starred_actor
FROM film_actor
JOIN ta1
USING(actor_id)
JOIN ta2
USING(film_id)
JOIN film f
USING(film_id)
JOIN actor a
USING(actor_id)
WHERE acted = max_act;