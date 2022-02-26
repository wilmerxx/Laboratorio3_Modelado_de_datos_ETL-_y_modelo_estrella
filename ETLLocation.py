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


def extraer_tabla_a_pandas(conectarDB):

    query = '''SELECT c.Address AS BillingAddress,
                c.City AS BillingCity,
                c.Country AS BillingCountry,
                s.States AS BillingState
            FROM customers c
            INNER JOIN State  s ON s.id_customers = c.CustomerId;'''
    result = conectarDB.execute(query)

    df = pd.DataFrame(result.fetchall())
    df.columns = result.keys()

    return df

    
def cargar_a_sql(datos, connectar, tabla_sqlite):

    # Procesamiento de completar los valores faltantes
    datos.to_sql(tabla_sqlite, connectar, if_exists='append', index=False, index_label="location_key")
    connectar.close()
    termino = print("carga terminada")
    return termino

if __name__ == '__main__':
    path = "sqlite:///chinook.db"
    path2 = "sqlite:///DW_Sales_Music.db"

    # Extracción
    extraerBD = extraer_database(path)

    #nombre_de_tabla = 'Invoices'
    engine = extraerBD[0]
    extraer = extraer_tabla_a_pandas(engine)
    
    
    # carga de los datos
    extraerNueva = extraer_database_nueva(path2)
   
    datos = extraer
    conectarNuevo = extraerNueva[1]
    tabla_sqlite = "dim_location"
    cargar_a_sql(datos, conectarNuevo, tabla_sqlite)
    print(extraer)

    
