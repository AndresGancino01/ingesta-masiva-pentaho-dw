-- ============================================================
-- Actividad 5 - Ingesta masiva con Pentaho Data Integration
-- Base de datos: dw_destino (Data Warehouse)
-- Ejecutar en pgAdmin 4 sobre la base dw_destino
-- ============================================================

-- Creacion de la capa de Staging para transacciones
CREATE TABLE IF NOT EXISTS stg_transacciones (
    id_transaccion INT,
    id_cliente VARCHAR(50),
    monto_total NUMERIC(12, 2),
    fecha_transaccion DATE,
    estado VARCHAR(30),
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indice para optimizar la carga incremental (marca de agua)
CREATE INDEX idx_stg_fch_act ON stg_transacciones(fecha_actualizacion);
