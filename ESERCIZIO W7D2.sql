/* Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
Quali considerazioni/ragionamenti è necessario che tu faccia? */
SELECT 
    COUNT(ProductKey) AS ConteggioRighe,
    COUNT(DISTINCT ProductKey) AS ConteggioDistinct
FROM
    dimproduct;

/* Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber 
sia una PK. */
SELECT 
    COUNT(*) AS TotalCount,
    COUNT(DISTINCT SalesOrderNumber, SalesOrderLineNumber) AS UniqueCount
FROM
    factresellersales;
    
/* Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020. */
SELECT 
    OrderDate, 
    COUNT(DISTINCT SalesOrderNumber) AS NumeroOrdini
FROM
    factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;

/* Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta 
(FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice) 
per prodotto (DimProduct) a partire dal 1 Gennaio 2020. Il result set deve esporre pertanto il nome 
del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
I campi in output devono essere parlanti! */
SELECT 
    dp.EnglishProductName,
    dp.ProductKey,
    SUM(frs.SalesAmount) AS FatturatoTotale,
    SUM(frs.Orderquantity) AS QuantitaTotale,
    AVG(frs.Unitprice) AS PrezzoMedio
FROM
    factresellersales AS frs
        JOIN
    dimproduct AS dp ON frs.ProductKey = dp.ProductKey
WHERE
    frs.OrderDate >= '2020.01.01'
GROUP BY dp.EnglishProductName , dp.ProductKey;

/* Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta 
(FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory). Il result set deve esporre 
pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in 
output devono essere parlanti! */
SELECT 
    dpc.EnglishProductCategoryName AS NomeCategoria,
    SUM(frs.SalesAmount) AS FatturatoTotale,
    SUM(frs.Orderquantity) AS QuantitaTotale
FROM
    dimproductcategory AS dpc
        JOIN
    dimproductsubcategory AS dpsc ON dpc.ProductCategoryKey = dpsc.ProductCategoryKey
        JOIN
    dimproduct AS dp ON dpsc.ProductSubcategoryKey = dp.ProductSubcategoryKey
        JOIN
    factresellersales AS frs ON dp.ProductKey = frs.ProductKey
GROUP BY dpc.EnglishProductCategoryName; 

/* Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K. */
SELECT 
    dg.City, SUM(frs.SalesAmount) AS TotaleFatturato
FROM
    factresellersales AS frs
        JOIN
    dimreseller AS dr ON frs.ResellerKey = dr.resellerkey
        JOIN
    dimgeography AS dg ON dr.GeographyKey = dg.GeographyKey
WHERE
    frs.OrderDate >= '2020-01-01'
GROUP BY dg.City