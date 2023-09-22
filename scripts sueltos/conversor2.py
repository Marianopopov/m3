import os
import pandas as pd

# Ruta de la carpeta con los archivos XLSX y CSV
carpeta = r'C:\Users\maria\Desktop\HENRY\m3\Clases\Clase 04\Homework'

# Lista de archivos en la carpeta
archivos = os.listdir(carpeta)

# Recorre los archivos en la carpeta
for archivo in archivos:
    # Verifica si el archivo es un archivo XLSX
    if archivo.endswith('.xls'):
        # Lee el archivo XLSX con pandas
        xls_path = os.path.join(carpeta, archivo)
        df = pd.read_excel(xls_path)

        # Crea el nombre del archivo CSV reemplazando la extensión
        csv_nombre = archivo.replace('.xls', '.csv')

        # Genera la ruta completa para el archivo CSV
        csv_path = os.path.join(carpeta, csv_nombre)

        # Guarda el DataFrame como archivo CSV
        df.to_csv(csv_path, index=False)

        print(f'Se ha convertido {archivo} a {csv_nombre}')