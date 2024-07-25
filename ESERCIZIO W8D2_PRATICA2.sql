/* Esercizio 1. Identificare tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006. */
SELECT 
    *
FROM
    customer
WHERE
    customer.customer_id NOT IN (SELECT DISTINCT
            customer.customer_id
        FROM
            rental
        WHERE
            YEAR(rental_date) = 2006
                AND MONTH(rental_date) = 01);

/* Esercizio 2. Elencate tutti i film che sono stati noleggiati più di 10 volte nell'ultimo quarto del 2006. */
SELECT 
    film.film_id, film.title, COUNT(rental_id)
FROM
    film
        JOIN
    inventory ON inventory.film_id = film.film_id
        JOIN
    customer ON customer.store_id = inventory.store_id
        JOIN
    rental ON rental.customer_id = customer.customer_id
WHERE
    QUARTER(rental_date) = 1
        AND YEAR(rental_date) = 2006
GROUP BY film.film_id , film.title;

/* Esercizio 3. Trovate il numero totale di noleggi effettuati il giorno 01/01/2006. */
SELECT 
    COUNT(*) AS NumeroTotaleNoleggi
FROM
    rental
WHERE
    DATE(rental_date) = '2006-01-01';

/* Esercizio 4. Calcolate la somma degli incassi generati nel weekend (sabato e domenica). */
SELECT
DAYNAME(payment_date),
SUM(amount)
FROM
payment
WHERE DAYNAME(payment_date) IN ('Saturday', 'Sunday')
GROUP BY DAYNAME(payment_date);

/* Esercizio 5. Individuate il cliente che ha speso di più in noleggi. */
SELECT 
    customer.first_name, customer.last_name, SUM(payment.amount)
FROM
    customer
        JOIN
    payment ON payment.customer_id = customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY SUM(payment.amount) DESC
LIMIT 1;

/* Esercizio 6. ELencate i 5 film con la maggior durata media di noleggio. */
SELECT 
    title, AVG(rental_duration) AS DurataMediaNoleggio
FROM
    film
GROUP BY title
ORDER BY DurataMediaNoleggio DESC
LIMIT 5;

/* Esercizio 7. Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente. */
SELECT 
    customer_id, AVG(DifferenzaNoleggiConsecutivi)
FROM
    (SELECT DISTINCT
        A.*,
            RR1.rental_date AS DataNoleggioPrecedente,
            RR2.rental_date AS DataNoleggioSuccessivo,
            DATEDIFF(RR2.rental_date, RR1.rental_date) AS DifferenzaNoleggiConsecutivi
    FROM
        (SELECT 
        r1.customer_id,
            r1.rental_id,
            MIN(r2.rental_id) AS NoleggioSuccessivo
    FROM
        rental AS r1
    LEFT JOIN rental AS r2 ON r1.customer_id = r2.customer_id
        AND r2.rental_id > r1.rental_id
    GROUP BY r1.customer_id , r1.rental_id) AS A
    LEFT JOIN RENTAL RR1 ON A.customer_id = RR1.customer_id
        AND A.rental_id = RR1.rental_id
    LEFT JOIN RENTAL RR2 ON A.customer_id = RR2.customer_id
        AND A.NoleggioSuccessivo = RR2.rental_id) AS AA
GROUP BY customer_id;

/* Esercizio 8. Individuate il numero di noleggi per ogni mese del 2005. */
SELECT 
    COUNT(rental_id), MONTHNAME(rental_date), YEAR(rental_date)
FROM
    rental
WHERE YEAR(rental_date) = 2005
GROUP BY MONTHNAME(rental_date), YEAR(rental_date)
ORDER BY MONTHNAME(rental_date) DESC;

/* Esercizio 9. Trovate i film che sono stati noleggiati almeno 2 volte nello stesso giorno. */
SELECT 
    title,
    COUNT(rental_date) AS N1,
    COUNT(DISTINCT DATE(rental_date)) AS N2
FROM
    rental
        JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
GROUP BY title
HAVING N1 <> N2
ORDER BY title;

/* Esercizio 10. Calcolate il tempo medio di noleggio. */
SELECT 
    AVG(DATEDIFF(return_date, rental_date)) AS DurataMediaNoleggio
FROM
    rental
