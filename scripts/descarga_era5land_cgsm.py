# -*- coding: utf-8 -*-
"""
Ejercicio 1 - Descarga ERA5-Land sobre la CGSM (enero 2024)
"""
import os
import cdsapi

DATA_DIR = "./data_heavy"
os.makedirs(DATA_DIR, exist_ok=True)
archivo_nc = os.path.join(DATA_DIR, "era5land_cgsm_t2m_ene2024.nc")

if os.path.exists(archivo_nc):
    print(f"Archivo ya existe: {archivo_nc}")
    raise SystemExit(0)

cliente = cdsapi.Client()
solicitud = {
    "variable": ["2m_temperature"],
    "year": "2024",
    "month": "01",
    "day": [f"{d:02d}" for d in range(1, 32)],
    "time": [f"{h:02d}:00" for h in range(0, 24)],
    "area": [11.2, -74.8, 10.5, -74.0],   # [N, W, S, E] CGSM
    "data_format": "netcdf",
    "download_format": "unarchived",
}

print("Encolando solicitud en CDS — espera variable según cola del servidor")
cliente.retrieve("reanalysis-era5-land", solicitud).download(archivo_nc)
print(f"Descarga finalizada en: {archivo_nc}")
print(f"Tamaño: {os.path.getsize(archivo_nc) / (1024**2):.2f} MB")
