------dim_custumer----------------------
CREATE TABLE dim_customers (
    CustomerId INTEGER      PRIMARY KEY,
    FirstName  VARCHAR (40),
    LastName   VARCHAR (20),
    Phone      VARCHAR (24),
    Email      VARCHAR (60) 
);

----------dim_employees---------------------
CREATE TABLE dim_employees (
    EmployeeId INTEGER      PRIMARY KEY AUTOINCREMENT,
    LastName   VARCHAR (20),
    FirstName  VARCHAR (20),
    Title      VARCHAR (30),
    Phone      VARCHAR (24),
    Email      VARCHAR (60) 
);

---------dim_location------------------------

CREATE TABLE dim_location (
    location_key   INTEGER PRIMARY KEY,
    BillingAddress VARCHAR,
    BillingCity    VARCHAR,
    BillingCountry VARCHAR,
    BillingState   VARCHAR
);

----------dim_albums--------------------------------

CREATE TABLE dim_albums (
    AlbumId  INTEGER        PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    Title_Album    NVARCHAR (160) NOT NULL
  
);

-----------dim_artist-----------------------------
CREATE TABLE dim_artists (
    ArtistId INTEGER        PRIMARY KEY AUTOINCREMENT
                            NOT NULL,
    Name_Artist     NVARCHAR (120) 
);

------------dim_track-----------------------------
CREATE TABLE dim_tracks (
    TrackId      INTEGER         PRIMARY KEY AUTOINCREMENT
                                 NOT NULL,
    Name_Track         NVARCHAR (200)  NOT NULL,
    MediaType        NVARCHAR (120), 
    Genre        NVARCHAR (120),
    Composer     NVARCHAR (220),
    Milliseconds INTEGER         NOT NULL,
    Bytes        INTEGER,
    UnitPrice    NUMERIC (10, 2) NOT NULL
  
);

-----------dim_invoice_items-------------------------------

CREATE TABLE dim_invoice_items (
    InvoiceLineId INTEGER         PRIMARY KEY,
    UnitPrice     NUMERIC (10, 2),
    Quantity      INTEGER
);

-----------dim_playlists-------------------------------


CREATE TABLE dim_playlists (
    PlaylistId INTEGER        PRIMARY KEY AUTOINCREMENT
                              NOT NULL,
    Name       NVARCHAR (120) 
);


------------dim_time----------------------------------

create table dim_time(
    DateSK INTEGER PRIMARY KEY NOT NULL,
    Date DATE not null,
    Day INTEGER not null,
    Month INTEGER not null,
    Year INTEGER not null,
    Quarter INTEGER not null,
    Week INTEGER not null,
    WeekDay INTEGER not null,
    Name_Day NVARCHAR(10) not null,
    Name_Month NVARCHAR(15) not null
);


------------------ Fact_sales---=>--tabla de hechos----------------

CREATE TABLE Fact_invoice_item (
    Id         INTEGER PRIMARY KEY AUTOINCREMENT
                       NOT NULL,
    InvoiceID  INTEGER REFERENCES dim_invoice_items (InvoiceLineId) 
                       NOT NULL,
    CustomerID INTEGER REFERENCES dim_customers (CustomerId) 
                       NOT NULL,
    EmployeeId INTEGER REFERENCES dim_employees (EmployeeId) 
                       NOT NULL,                   
    TimeID     INTEGER REFERENCES dim_time (DateSK) 
                       NOT NULL,
    LocationID INTEGER REFERENCES dim_location (location_key) 
                       NOT NULL,
    TrackId INTEGER REFERENCES dim_tracks (TrackId) 
                       NOT NULL,
    PlaylistID INTEGER REFERENCES dim_playlists (PlaylistId) 
                       NOT NULL,
    ArtistID   INTEGER REFERENCES dim_artists (ArtistId) 
                       NOT NULL,
    AlbumID    INTEGER REFERENCES dim_albums (AlbumId) 
                       NOT NULL,
    Total             NUMERIC (10, 2) NOT NULL
);

