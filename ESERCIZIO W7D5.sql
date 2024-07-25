/*Esercizio 1. Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che 
hanno meno di 10 tracce. */
SELECT 
    gn.Name, tk.GenreId, COUNT(tk.GenreId) AS NumeroTracce
FROM
    track AS tk
        JOIN
    genre AS gn ON gn.GenreId = tk.GenreId
GROUP BY gn.Name , gn.GenreId
HAVING (NumeroTracce >= 10)
ORDER BY NumeroTracce DESC;

/*Esercizio 2. Trovate le tre canzoni più costose. */
SELECT 
    Name,
    UnitPrice
FROM
    track
ORDER BY UnitPrice DESC;

/*Esercizio 3. Elencate gli artisti che hanno canzoni più lunghe di 6 minuti. */
SELECT DISTINCT
    art.Name, tk.Milliseconds
FROM
    track AS tk
        JOIN
    album AS alb ON alb.AlbumId = tk.AlbumId
        JOIN
    artist AS art ON art.ArtistId = alb.ArtistId
WHERE tk.Milliseconds >= 360000;

/*Esercizio 4. Individuate la durata media delle tracce per ogni genere. */
SELECT
    gn.Name, AVG(tk.Milliseconds)
FROM
    track AS tk
        JOIN
    genre AS gn ON tk.GenreId = gn.GenreId
GROUP BY gn.Name;

/*Esercizio 5. Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima 
per genere e poi per nome. */
SELECT 
    gn.Name AS Genere, tk.Name AS TitoloCanzone
FROM
    track AS tk
        JOIN
    genre AS gn ON gn.GenreId = tk.GenreId
GROUP BY tk.Name , gn.Name
HAVING TitoloCanzone LIKE '%Love%'
ORDER BY gn.Name ASC , tk.Name ASC;

/*Esercizio 6. Trovate il costo medio per ogni tipologia di media.*/
SELECT DISTINCT
    mt.Name, AVG(tk.UnitPrice) AS PrezzoMedio
FROM
    mediatype AS mt
        JOIN
    track AS tk ON mt.MediaTypeId = tk.MediaTypeId
GROUP BY mt.Name;

/* Esercizio 7. Individuate il genere con più tracce. */
SELECT 
gn.Name, COUNT(*) AS NumeroTracce
FROM genre AS gn
JOIN track AS tk ON tk.GenreId = gn.GenreId
GROUP BY gn.Name
LIMIT 1;

/* Esercizio 8. Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.*/
SELECT
    art.Name, COUNT(alb.Title) AS NumeroAlbum
FROM
    album AS alb
        LEFT JOIN
    artist AS art ON alb.ArtistId = art.ArtistId
GROUP BY art.Name
HAVING NumeroAlbum = (SELECT 
        COUNT(alb.Title) AS NumeroAlbum
    FROM
        album AS alb
            LEFT JOIN
        artist AS art ON alb.ArtistId = art.ArtistId
    WHERE
        art.Name = 'The Rolling Stones');

/* Esercizio 9. Trovate l’artista con l’album più costoso. */
SELECT 
    art.Name AS Artista,
    alb.Title AS TitoloAlbum,
    SUM(tk.UnitPrice) AS CostoAlbum
FROM
    artist AS art
        JOIN
    album AS alb ON alb.ArtistId = art.ArtistId
        JOIN
    track AS tk ON tk.AlbumId = alb.AlbumId
GROUP BY Artista , TitoloAlbum
ORDER BY CostoAlbum DESC
LIMIT 1
        
