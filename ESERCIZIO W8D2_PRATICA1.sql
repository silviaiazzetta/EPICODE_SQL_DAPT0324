/* Esercizio 2. Scoprite quanti clienti si sono registrati nel 2006. */
SELECT 
    YEAR(create_date) AS AnnoRegistrazione,
    COUNT(customer_id) AS NumeroClienti
FROM
    customer
WHERE
    YEAR(create_date) = '2006'
GROUP BY YEAR(create_date);

/* Esercizio 3. Trovate il numero totale di noleggi effettuati il giorno 24/05/2005. */
SELECT 
    COUNT(rental_id) AS NumeroTotaleNoleggi
FROM
    rental
WHERE
    DATE(rental_date) = '2005-05-24';
    
/*Esercizio 4. Elencate tutti i film noleggiati nell'ultima settimana e tutte le informazioni legate 
al cliente che li ha nolegiati. */
SELECT 
    film.title,
    customer.first_name,
    customer.last_name,
    customer.email,
    rental.rental_date
FROM
    film
        JOIN
    inventory ON inventory.film_id = film.film_id
        JOIN
    rental ON rental.inventory_id = inventory.inventory_id
        JOIN
    customer ON customer.customer_id = rental.customer_id
WHERE
    DATE(rental.rental_date) BETWEEN '2006-02-08' AND '2006-02-14';

/* Esercizio 5. Calcolate la durata media del noleggio per ogni categoria di film. */
SELECT 
    A.Categoria,
    A.MediaDurataNoleggio,
    B.MediaDurataNoleggio_datediff
FROM
    (SELECT 
        category.name AS Categoria,
            AVG(film.rental_duration) AS MediaDurataNoleggio
    FROM
        film
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    GROUP BY category.name) AS A
        JOIN
    (SELECT 
        category.name AS Categoria,
            AVG(DATEDIFF(return_date, rental_date)) AS MediaDurataNoleggio_datediff
    FROM
        rental
    JOIN inventory ON inventory.inventory_id = rental.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    GROUP BY category.name) AS B ON A.Categoria = B.Categoria;

/* Esercizio 6. Trovate la durata del noleggio più lungo. */
SELECT 
    MAX(DATEDIFF(return_date, rental_date)) AS DurataMassimaNoleggio
FROM
    rental