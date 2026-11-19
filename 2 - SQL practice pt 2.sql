---------------------------------------------
--------- SQL in practice - part 2 ----------
---------------------------------------------

---- DIGITAL FUTURES
---- SQL: JOINS, CASE, UNION & more practice TEST CHANGE

-----------------------------------------------------------------------------------------------------------
-------- CONTENTS
-----------------------------------------------------------------------------------------------------------
/*
DF10	INNER JOINS
DF11	LEFT & RIGHT JOINS
DF12	FULL JOINS
DF13	CASE 
DF14    UNION 
DF-A	PRACTICE TASKS
*/

-----------------------------------------------------------------------------------------------------------
-------- DF10 -- INNER JOINS test change
-----------------------------------------------------------------------------------------------------------


-- Let's go to EXCEL! 






-- EX -- Let's join customer, address, city and country! 
SELECT *
FROM main.customer cu 
INNER JOIN main.address a 
USING (address_id)
INNER JOIN main.city ci 
USING (city_id)
INNER JOIN main.country co
USING(country_id);




-- EX -- Combining joins with other queries. 
      -- List each film and the number of actors who are listed for that film.
SELECT f.title , COUNT(f.film_id)
FROM main.film f 
INNER JOIN main.film_actor fa 
USING(film_id)
GROUP BY f.film_id;


------------------------
-------- DF10 -- TASKS
------------------------
-- Task 1 -- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, count(i.inventory_id)
FROM main.film f
INNER JOIN main.inventory i 
USING(film_id)
GROUP BY f.film_id
HAVING f.title ='Hunchback Impossible';



-- Task 2 -- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name
SELECT c.first_name,c.last_name, sum(p.amount)
FROM main.payment p 
INNER JOIN main.customer c 
USING(customer_id)
GROUP BY c.customer_id ;




-- Task 3 -- Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, c2.country 
FROM main.store s 
INNER JOIN main.address a 
USING (address_id)
INNER JOIN main.city c 
USING (city_id)
INNER JOIN main.country c2 
USING (country_id);


-----------------------------------------------------------------------------------------------------------
-------- DF11 -- LEFT & RIGHT JOINS
-----------------------------------------------------------------------------------------------------------



-- Task 1 --
          -- The marketing team are having a really tough day in the office, and running out of ideas. 
		  -- Their best idea, is to let people know how many films have actors in that share the same first name as the customer? 
		  -- For example. If a customer is called Alex. We want to let them know how many films have an actor called Alex in! 
SELECT c.first_name, count(f.film_id)
FROM main.customer c 
LEFT JOIN main.actor a
USING (first_name)
INNER JOIN main.film_actor fa
USING(actor_id)
INNER JOIN main.film f
using(film_id)
GROUP BY c.first_name
ORDER BY c.first_name;
		  
-- Task 2 -- Create a list of all of the languages (by Name), and how many films we have in that language.
          -- If there are no films in that language, it should display 0.
          -- Order by the name of the language
          
SELECT l."name", COUNT(f.film_id) AS film_count
FROM main."language" l
LEFT JOIN main.film f USING (language_id)
GROUP BY l.language_id, l."name"
ORDER BY film_count ;

-----------------------------------------------------------------------------------------------------------
-------- DF12 -- FULL JOINS
-----------------------------------------------------------------------------------------------------------

-- Task 1 -- Can you find any situation in the DB that needs a full join?
-- if we have a case where there may be missing infomation in both original tables for example there are 2 stores
-- that might not share the same films
-----------------------------------------------------------------------------------------------------------
-------- DF13 -- CASE
-----------------------------------------------------------------------------------------------------------

-- EX --Let's use case to categorise the payment types as small, medium or large.
SELECT
	CASE
		WHEN amount <= 2 THEN 'Small'
		WHEN amount <= 7 THEN 'Medium'
		ELSE 'Large'
	END AS SIZE
	, p.amount 
FROM main.payment p ;



-- EX -- Let's combine that CASE statement with group by 

SELECT
	CASE
		WHEN amount <= 2 THEN 'Small'
		WHEN amount <= 7 THEN 'Medium'
		ELSE 'Large'
	END AS payment_size
	, count(amount)
FROM main.payment p 
GROUP BY payment_size;

-- EX -- What if we want the average payment within each of those groups?



-- EX -- What if we want the counts!


-- Task 1 --
          -- Create a list of all of the category_ids and whether they are fiction or non fiction 
		  -- travel, sports and documentaries are non_fiction! 
SELECT c.name,
CASE
	WHEN c.name IN ('Travel','Sports','Documentary') THEN 'non_fiction'
	ELSE 'fiction'
END fict_or_nonfict
FROM main.category c;
-- Task 2 -- 
		  -- Create a list of rentals which a column based on whether it was a long or short rental. 
		  -- less than 2 days is short, anything longer is long! 
SELECT r.rental_id,
CASE
	WHEN r.return_date::date-r.rental_date::date < 2 THEN 'short'
	ELSE 'Long'
END
FROM main.rental r;
		
-----------------------------------------------------------------------------------------------------------
-------- DF14 -- UNION
-----------------------------------------------------------------------------------------------------------
-- Union lets us join together 2 sets of data, glueing them on top of each other.



-- What does Union All do? 


-- Task 
   -- Use SELECT to create some data (without selecting from the DB)
   -- e.g. SELECT 'HELLO', 'GOODBYE', 'SUP' 
   -- Do this a couple of times and UNION and UNION ALL them together. 
   -- What are the rules of UNION? 
   -- What are the rules of UNION ALL?
   



-----------------------------------------------------------------------------------------------------------
-------- DF-A -- TASKS
-----------------------------------------------------------------------------------------------------------

-- Task 1 -- 
-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title film_name
FROM main.film f 
WHERE LEFT(f.title,1) IN ('K','Q') AND f.language_id = 1
ORDER BY f.title;

-- Task 2 -- 
-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name ,c.email,c3.country  
FROM main.customer c 
INNER JOIN main.address a 
USING(address_id)
INNER JOIN main.city c2 
using(city_id)
INNER JOIN main.country c3 
using(country_id)
WHERE c3.country ='Canada';
-- TASK 3 -- 
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.
SELECT f.title,c."name" 
FROM main.film f
INNER JOIN main.film_category fc 
using(film_id)
INNER JOIN main.category c 
using(category_id)
WHERE c."name" ='Family'
ORDER BY f.title;
-- TASK 4 -- 
-- Display the most frequently rented movies in descending order.
SELECT f.title,Count(r.rental_id) times_rented
FROM main.film f
INNER JOIN main.inventory i 
USING(film_id)
INNER JOIN main.rental r
using(inventory_id)
GROUP BY f.film_id
HAVING count(r.rental_id)>=30
ORDER BY times_rented DESC;
-- TASK 5 -- 
-- Write a query to display how much business, in dollars, each store brought in.
SELECT i.store_id, SUM(p.amount) AS total_revenue
FROM main.payment p
JOIN main.rental r USING (rental_id)
JOIN main.inventory i USING (inventory_id)
GROUP BY i.store_id;
-- TASK 6 -- 
-- List the top five genres in gross revenue in descending order.
SELECT c.name 
FROM main.film f
INNER JOIN main.inventory i 
USING(film_id)
INNER JOIN main.rental r 
using(inventory_id)
INNER JOIN main.payment p
USING (rental_id)
INNER JOIN main.film_category fc 
USING (film_id)
INNER JOIN main.category c
USING (category_id)
GROUP BY c."name"
ORDER BY sum(p.amount) DESC 
LIMIT 5;


-- Bonus Where  -- Working with Full Text Search
-- https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/