select * from dim_albums;

select * from dim_artists;

select * from dim_customers;

select * from dim_employees;

select * from dim_invoice_items;

select * from dim_location;

select * from dim_playlists;

select * from dim_tracks;

select * from dim_time;

---delete FROM dim_time;

select * from Fact_invoice_item;

---delete FROM Fact_invoice_item;
--DROP TABLE Fact_invoice_item;


SELECT dim_customers.LastName AS [NOMBRE CLIENTE],
       dim_employees.FirstName AS [NOMBRE DE EMPLEADO],
       dim_customers.Phone AS [TELEFONO CLIENTE],
       dim_tracks.Name_Track AS PISTA,
       dim_time.Date AS [FECHA],
       dim_time.Name_Day AS [DIA],
       dim_time.Name_Month AS [MES],
       dim_time.Year AS [AÑO],
       Fact_invoice_item.Total AS [TOTAL]
  FROM Fact_invoice_item
       INNER JOIN dim_albums ON dim_albums.AlbumId = Fact_invoice_item.AlbumID
       INNER JOIN dim_artists ON dim_artists.ArtistId = Fact_invoice_item.ArtistID
       INNER JOIN dim_customers ON dim_customers.CustomerId = Fact_invoice_item.CustomerID
       INNER JOIN dim_employees ON dim_employees.EmployeeId = Fact_invoice_item.EmployeeId
       INNER JOIN dim_invoice_items ON dim_invoice_items.InvoiceLineId = Fact_invoice_item.InvoiceLineId
       INNER JOIN dim_location ON dim_location.location_key = Fact_invoice_item.LocationID
       INNER JOIN dim_playlists ON dim_playlists.PlaylistId = Fact_invoice_item.PlaylistID
       INNER JOIN dim_time ON dim_time.DateSK = Fact_invoice_item.TimeID
       INNER JOIN dim_tracks ON dim_tracks.TrackId = Fact_invoice_item.TrackId
       GROUP BY [NOMBRE CLIENTE]
       ORDER BY [TOTAL] DESC
       
 LIMIT 3;

