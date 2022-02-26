SELECT Title AS Title_Album FROM albums;

SELECT Name AS Name_Artist FROM artists;

SELECT FirstName,LastName,Phone,Email 
FROM customers;

SELECT LastName,FirstName,Title,Phone,Email 
FROM employees;

SELECT UnitPrice,Quantity 
FROM invoice_items;

SELECT UnitPrice,Quantity 
FROM invoice_items
WHERE Quantity IS NULL;

SELECT DISTINCT BillingAddress,BillingCity,BillingCountry,BillingState
FROM invoices;

SELECT c.Address AS BillingAddress,
    c.City AS BillingCity,
    c.Country AS BillingCountry,
    s.States AS BillingState
FROM customers c
INNER JOIN State  s ON s.id_customers = c.CustomerId;

SELECT *
FROM invoices;

SELECT BillingAddress,BillingCity,BillingState,BillingCountry 
FROM invoices
WHERE BillingState IS NULL;
------------------------datos para la dimension playlists-----------
SELECT Name AS Name_playlist
  FROM playlists;
  
  SELECT * FROM playlists;
  
------------------------datos para la dimension location-----------

SELECT c.Address AS BillingAddress,
       c.City AS BillingCity,
       c.Country AS BillingCountry,
       s.States AS BillingState
  FROM customers c
       INNER JOIN
       State s ON s.id_customers = c.CustomerId;

-------------Datos para la dimension tracks-----------------

SELECT T.Name AS Name_Track,
       M.Name AS MediaType,
       G.Name AS Genre,
       T.Composer,
       T.Milliseconds,
       T.Bytes,
       T.UnitPrice
  FROM tracks T
       INNER JOIN
       media_types M ON M.MediaTypeId = T.MediaTypeId
       INNER JOIN
       genres G ON G.GenreId = T.GenreId;
       
------------Consulta para la tabla de hechos-------------------------

SELECT INV.InvoiceLineId AS InvoiceID,
       C.CustomerId AS CustomerID,
       E.EmployeeId,
       I.InvoiceId AS TimeID,
       I.InvoiceId AS LocationID,
       T.TrackId,
       PL.PlaylistId AS PlaylistID,
       AR.ArtistId AS ArtistID,
       A.AlbumId AS AlbumID,
       I.Total
  FROM employees E
       INNER JOIN
       customers C ON C.SupportRepId = E.EmployeeId
       INNER JOIN
       invoices I ON I.CustomerId = C.CustomerId
       INNER JOIN
       invoice_items INV ON INV.InvoiceId = I.InvoiceId
       INNER JOIN
       tracks T ON T.TrackId = INV.TrackId
       INNER JOIN
       playlist_track P ON P.TrackId = T.TrackId
       INNER JOIN
       playlists PL ON PL.PlaylistId = P.PlaylistId
       INNER JOIN
       albums A ON A.AlbumId = T.AlbumId
       INNER JOIN
       artists AR ON AR.ArtistId = A.ArtistId
       GROUP BY INV.InvoiceLineId
 LIMIT 5;
 
select * from invoices;



