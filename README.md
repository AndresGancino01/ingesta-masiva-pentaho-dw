# Ingesta masiva de datos con Pentaho Data Integration (PDI)

**Universidad Indoamérica - Ciencia de Datos - Actividad 5**
**Autor:** Andrés Gancino

Flujo ETL que extrae transacciones desde una base de datos transaccional (OLTP) en PostgreSQL, las limpia, estandariza y deduplica con Pentaho Data Integration, y las carga en una tabla de Staging (`stg_transacciones`) de un Data Warehouse.

## Entorno

- Windows 11
- PostgreSQL 18 y pgAdmin 4
- Pentaho Data Integration Community Edition 11.0.0.2-294 (Spoon)
- JDK 17

## Estructura del repositorio

```
.
├── README.md
├── pentaho/
│   └── TR_Ingesta_Masiva_Transacciones.ktr
├── sql/
│   ├── 01_origen_transacciones.sql
│   ├── 02_staging_stg_transacciones.sql
│   ├── 03_verificacion.sql
│   └── 04_consulta_table_input.sql
└── docs/
    ├── Informe_Actividad5_Ingesta_Masiva_Pentaho.pdf
    ├── Criterios_de_Calidad.pdf
    └── Guia_Practica_Ingesta_Masiva_Pentaho_UTI.pdf
```

## Cómo reproducir la práctica

1. En pgAdmin crear las bases de datos `oltp_origen` y `dw_destino`.
2. Ejecutar `sql/01_origen_transacciones.sql` sobre `oltp_origen` (5103 registros de prueba: 5000 base, 100 duplicados y 3 con nulos o valores inválidos).
3. Ejecutar `sql/02_staging_stg_transacciones.sql` sobre `dw_destino`.
4. En Spoon, abrir `pentaho/TR_Ingesta_Masiva_Transacciones.ktr` y crear las conexiones `conn_origen` (oltp_origen) y `conn_destino` (dw_destino) con sus credenciales de PostgreSQL.
5. Ejecutar la transformación (Run > Launch).
6. Verificar con `sql/03_verificacion.sql` sobre `dw_destino`.

## Flujo de la transformación

`Table input` → `Select values` → `Null if` → `If field value is null` → `Sort rows` → `Unique rows` → `Table output`

| Paso | Función |
|---|---|
| Table input | Extrae los registros de `transacciones_origen` filtrando por `fecha_actualizacion` |
| Select values | Estandariza nombres y tipos de datos (Number, Date yyyy-MM-dd) |
| Null if | Convierte valores inválidos ("N/A" y vacíos) en nulos |
| If field value is null | Imputa `monto_total` = 0 y `estado` = 'No registrado' |
| Sort rows | Ordena por `id_transaccion` y `fecha_actualizacion` descendente |
| Unique rows | Conserva un solo registro por `id_transaccion` (el más reciente) |
| Table output | Carga en `stg_transacciones` (Truncate table activado) |

## Resultados de la ejecución

- Registros leídos: 5103
- Registros escritos: 5003 (100 duplicados eliminados)
- Errores: 0

## Documentación

- `docs/Informe_Actividad5_Ingesta_Masiva_Pentaho.pdf`: informe de resolución con capturas de pantalla.
- `docs/Criterios_de_Calidad.pdf`: criterios de calidad de datos aplicados.
- `docs/Guia_Practica_Ingesta_Masiva_Pentaho_UTI.pdf`: guía práctica de la asignatura (contexto del ejercicio).
