from datetime import date
from datetime import timedelta
import pandas as pd
import sqlalchemy

'''Procesos de ETL'''

def extraer_database(path):

    motorDB = sqlalchemy.create_engine(path)
    conectarDB = motorDB.connect()

    return motorDB, conectarDB


def extraer_database_nueva(path):
    
    motorDB_nueva = sqlalchemy.create_engine(path)
    conectarDB_nueva = motorDB_nueva.connect()

    return motorDB_nueva, conectarDB_nueva

def extraer_tabla_a_sql(conectarDB):
    
    query = '''SELECT INV.InvoiceLineId AS InvoiceLineId,
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
                INNER JOIN customers C ON C.SupportRepId = E.EmployeeId
                INNER JOIN invoices I ON I.CustomerId = C.CustomerId
                INNER JOIN invoice_items INV ON INV.InvoiceId = I.InvoiceId
                INNER JOIN tracks T ON T.TrackId = INV.TrackId
                INNER JOIN playlist_track P ON P.TrackId = T.TrackId
                INNER JOIN playlists PL ON PL.PlaylistId = P.PlaylistId
                INNER JOIN albums A ON A.AlbumId = T.AlbumId
                INNER JOIN artists AR ON AR.ArtistId = A.ArtistId
                GROUP BY INV.InvoiceLineId'''
    result = conectarDB.execute(query)
    df = pd.DataFrame(result.fetchall())
    df.columns = result.keys()
    return df


def cargar_a_sql(datos, connectar, tabla_sqlite):
    
    # Procesamiento de completar los valores faltantes
    datos.to_sql(tabla_sqlite, connectar, if_exists='append', index=False)
    connectar.close()
    termino = print("carga terminada")
    return termino

if __name__ == '__main__':
    path = "sqlite:///DW_Sales_Music.db"
    path2 = "sqlite:///chinook.db"
    # Extracción
    extraer = extraer_database(path2)
    engine = extraer[0]
    extraer_data = extraer_tabla_a_sql(engine)
    extraer2 = extraer_database_nueva(path)
    engine2 = extraer2[1]
    
    # carga de los datos
    
    datos = extraer_data
    print(datos)
    tabla_sqlite = "Fact_invoice_item"
    cargar_a_sql(datos, engine2, tabla_sqlite)
    print(extraer)
   
