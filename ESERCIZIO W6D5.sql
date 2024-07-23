/* Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria 
(DimProduct, DimProductSubcategory). */
SELECT 
    dp.ProductKey,
    dp.ProductSubcategoryKey,
    dp.EnglishProductName,
    dps.EnglishProductSubcategoryName
FROM
    dimproduct AS dp
        JOIN
    dimproductsubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey;

/* .Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria 
(DimProduct, DimProductSubcategory, DimProductCategory). */
SELECT 
    dp.ProductKey,
    dp.ProductSubcategoryKey,
    dp.EnglishProductName,
    dps.ProductCategoryKey,
    dps.EnglishProductSubcategoryName,
    dpc.EnglishProductCategoryName
FROM
    dimproduct AS dp
        JOIN
    dimproductsubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
        JOIN
    dimproductcategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey;

/* Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales). */
-- UTILIZZANDO JOIN
SELECT 
    dp.ProductKey,
    dp.EnglishProductName
FROM
    dimproduct AS dp
        JOIN
    factresellersales AS frs ON dp.ProductKey = frs.ProductKey;

-- UTILIZZANDO SUBQUERY
SELECT 
    dp.ProductKey,
    dp.EnglishProductName
FROM
    dimproduct AS dp
    WHERE dp.ProductKey IN (SELECT frs.ProductKey FROM factresellersales AS frs);
    
/* Esponi l’elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il 
campo FinishedGoodsFlag è uguale a 1). */
-- UTILIZZANDO JOIN
SELECT 
    dp.ProductKey,
    dp.EnglishProductName,
    dp.FinishedGoodsFlag
FROM
    dimproduct AS dp
        LEFT JOIN
    factresellersales AS frs ON dp.ProductKey = frs.ProductKey
WHERE
    frs.ProductKey IS NULL
        AND dp.FinishedGoodsFlag = 1;
        
-- UTILIZZANDO SUBQUERY
SELECT 
    dp.ProductKey, dp.EnglishProductName, dp.FinishedGoodsFlag
FROM
    dimproduct AS dp
WHERE
    dp.FinishedGoodsFlag = 1
        AND dp.ProductKey NOT IN (SELECT 
            frs.ProductKey
        FROM
            factresellersales AS frs);

/* Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto 
venduto (DimProduct). */
-- UTILIZZANDO JOIN
SELECT 
    dp.ProductKey,
    dp.EnglishProductName,
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost
FROM
    dimproduct AS dp
        JOIN
    factresellersales AS frs ON dp.ProductKey = frs.ProductKey;
    
-- UTILIZZANDO SUBQUERY
SELECT 
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    (SELECT 
            dp.EnglishProductName
        FROM
            dimproduct AS dp
        WHERE
            dp.ProductKey = frs.ProductKey) AS ProductName,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost
FROM
    factresellersales AS frs;

/* Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto. */
SELECT 
    dp.ProductKey,
    dp.ProductSubcategoryKey,
    dp.EnglishProductName,
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost,
    dps.ProductSubcategoryKey,
    dps.ProductCategoryKey
FROM
    factresellersales AS frs
        LEFT JOIN
    dimproduct AS dp ON frs.ProductKey = dp.ProductKey
        LEFT JOIN
    dimproductsubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
        LEFT JOIN
    dimproductcategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey;
    
/* Esplora la tabella DimReseller. */
SELECT 
    *
FROM
    dimreseller;
    
/* Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica. */
SELECT 
    dr.ResellerKey,
    dr.GeographyKey,
    dr.ResellerName,
    dg.EnglishCountryRegionName,
    dg.City
FROM
    dimreseller AS dr
        JOIN
    dimgeography AS dg ON dr.GeographyKey = dg.GeographyKey;
    
/* Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, 
SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. Il result set deve anche indicare il 
nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l’area geografica. */
SELECT 
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost,
    dp.EnglishProductName,
    dps.EnglishProductSubcategoryName,
    dpc.EnglishProductCategoryName,
    dg.EnglishCountryRegionName,
    dr.ResellerName
FROM
    factresellersales AS frs
        JOIN
    dimproduct AS dp ON dp.ProductKey = frs.ProductKey
        JOIN
    dimproductsubcategory AS dps ON dps.ProductSubcategoryKey = dp.ProductSubcategoryKey
        JOIN
    dimproductcategory AS dpc ON dpc.ProductCategoryKey = dps.ProductCategoryKey
        JOIN
    dimgeography AS dg ON dg.SalesTerritoryKey = frs.SalesTerritoryKey
        JOIN
    dimreseller AS dr ON dr.GeographyKey = dg.GeographyKey

