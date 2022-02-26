import sqlite3
import numpy
import glob
import matplotlib.pyplot as plt
from datetime import datetime

import pandas as pd
import sqlalchemy

'''Procesos de ETL'''
#Conexion de la base de datos chinook.db
def extraer_database(path):
    motorDB = sqlalchemy.create_engine(path)
    conectarDB = motorDB.connect()
    return motorDB, conectarDB

#Conexion de la base de datos DW_sale_Music.db
def extraer_database_nueva(path):
    motorDB_nueva = sqlalchemy.create_engine(path)
    conectarDB_nueva = motorDB_nueva.connect()
    return motorDB_nueva, conectarDB_nueva

#Extraer datos de la base de datos chinook
def extraer_tabla_a_pandas(conectarDB):

    query = '''SELECT T.Name AS Name_Track,
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
                    genres G ON G.GenreId = T.GenreId;'''
    result = conectarDB.execute(query)
    df = pd.DataFrame(result.fetchall())
    df.columns = result.keys()
    return df

#Transformacion de datos nulos
def transformar_rellenar_nulo(datos):
    # Procesamiento de completar los valores faltantes
    datos = datos.fillna({"Composer": "NA"})

    return datos


def cargar_a_sql(datos, connectar, tabla_sqlite):

    # Procesamiento de completar los valores faltantes
    datos.to_sql(tabla_sqlite, connectar, if_exists='append', index=False)
    connectar.close()
    termino = print("carga terminada")
    return termino

if __name__ == '__main__':
    path = "sqlite:///chinook.db"
    path2 = "sqlite:///DW_Sales_Music.db"

    # Extracción
    extraerBD = extraer_database(path)

    engine = extraerBD[0]
    extraer = extraer_tabla_a_pandas(engine)

    # Transformación
    transformar = transformar_rellenar_nulo(extraer)

    # carga de los datos
    extraerNueva = extraer_database_nueva(path2)
    datos = transformar
    conectarNuevo = extraerNueva[1]
    tabla_sqlite = "dim_tracks"
    cargar_a_sql(datos, conectarNuevo, tabla_sqlite)
    print(extraer)
