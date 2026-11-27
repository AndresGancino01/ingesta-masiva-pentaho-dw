-- ============================================================
-- Actividad 5 - Verificacion posterior a la ejecucion del .ktr
-- Ejecutar en pgAdmin 4 sobre la base dw_destino
-- ============================================================

-- Total de registros cargados (esperado: 5003)
SELECT COUNT(*) FROM stg_transacciones;

-- Duplicados por clave de negocio (esperado: 0 filas)
SELECT id_transaccion, COUNT(*) FROM stg_transacciones
GROUP BY id_transaccion HAVING COUNT(*) > 1;

-- Nulos criticos (esperado: 0)
SELECT COUNT(*) FROM stg_transacciones
WHERE monto_total IS NULL OR estado IS NULL;

-- Registros de prueba corregidos (monto_total = 0 y estado = 'No registrado')
SELECT * FROM stg_transacciones
WHERE id_transaccion IN (9001,9002,9003);
