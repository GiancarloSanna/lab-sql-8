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





select * from country;
select * from store;
select * from city;
select * from film_category;
select * from address;
select * from rental;
select * from customer;
select* from film_actor;
select * from actor;
select * from film;
select * from category;
select * from film_category;
select * from staff;
select* from payment;
select * from inventory;
select* from film_actor;