-- ============================================================
-- Actividad 5 - Ingesta masiva con Pentaho Data Integration
-- Base de datos: oltp_origen (sistema transaccional de origen)
-- Ejecutar en pgAdmin 4 sobre la base oltp_origen
-- ============================================================

CREATE TABLE transacciones_origen (
    id_transaccion INT,
    id_cliente VARCHAR(50),
    monto_total NUMERIC(12,2),
    fecha_transaccion DATE,
    estado VARCHAR(30),
    fecha_actualizacion TIMESTAMP
);

-- 5000 registros base
INSERT INTO transacciones_origen
SELECT g,
       'CLI' || (g % 300),
       round((random()*500)::numeric, 2),
       CURRENT_DATE - (g % 365),
       (ARRAY['Pagado','Pendiente','Anulado'])[1 + g % 3],
       now() - (g || ' minutes')::interval
FROM generate_series(1, 5000) g;

-- 100 duplicados con fecha de actualizacion mas reciente (prueba de deduplicacion)
INSERT INTO transacciones_origen
SELECT id_transaccion, id_cliente, monto_total + 10, fecha_transaccion, estado, now()
FROM transacciones_origen WHERE id_transaccion <= 100;

-- 3 registros con nulos y valores invalidos (prueba de calidad de datos)
INSERT INTO transacciones_origen VALUES
(9001,'CLI1',NULL,CURRENT_DATE,'N/A',now()),
(9002,'CLI2',50,CURRENT_DATE,'',now()),
(9003,'CLI3',NULL,CURRENT_DATE,NULL,now());

-- Comprobacion: debe devolver 5103
SELECT COUNT(*) FROM transacciones_origen;
