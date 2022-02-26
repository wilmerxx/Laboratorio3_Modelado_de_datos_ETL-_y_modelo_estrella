import sqlite3
import numpy
import glob
import matplotlib.pyplot as plt
import pandas as pd
import sqlalchemy

'''Procesos de ETL'''
'''Conexión de la bases de dato 
entrada: ruta de la conexión
salida: conexion y motor de la base de datos'''
def extraer_database(path):

    motorDB = sqlalchemy.create_engine(path)
    conectarDB = motorDB.connect()

    return motorDB, conectarDB

def extraer_database_nueva(path):
    
    motorDB_nueva = sqlalchemy.create_engine(path)
    conectarDB_nueva = motorDB_nueva.connect()

    return motorDB_nueva, conectarDB_nueva

'''Función para la extracción de los datos
entrada: conexión a la base de datos chinook
salida: dataFrame'''

def extraer_tabla_a_pandas(conectarDB):

    query = '''SELECT Title AS Title_Album FROM albums;'''
    result = conectarDB.execute(query)
    df = pd.DataFrame(result.fetchall())
    df.columns = result.keys()

    return df

'''Carga de los datos
entrada: dataFrame, conexión, nombre de la tabla
salida: mensaje de confirmación'''

def cargar_a_sql(datos, connectar, tabla_sqlite):

    # Procesamiento de completar los valores faltantes
    datos.to_sql(tabla_sqlite, connectar, if_exists='append', index=False)
    connectar.close()
    termino = print("carga terminada")
    return termino

'''Funcion principal del programa
ejecución de las funciones'''

if __name__ == '__main__':
    path = "sqlite:///chinook.db"
    path2 = "sqlite:///DW_Sales_Music.db"

    # Extracción
    extraerBD = extraer_database(path)
    engine = extraerBD[0]
    extraer = extraer_tabla_a_pandas(engine)

    # carga de los datos
    extraerNueva = extraer_database_nueva(path2)
    datos = extraer
    conectarNuevo = extraerNueva[1]
    tabla_sqlite = "dim_albums"
    cargar_a_sql(datos, conectarNuevo, tabla_sqlite)
    print(extraer)
