-- Consulta utilizada en el paso Table input de Pentaho (conexion conn_origen)
-- Sin punto y coma final ni parametro "?" (esa version inicial produjo un error de sintaxis)
SELECT id_transaccion, id_cliente, monto_total,
       fecha_transaccion, estado, fecha_actualizacion
FROM transacciones_origen
WHERE fecha_actualizacion >= '2000-01-01'
