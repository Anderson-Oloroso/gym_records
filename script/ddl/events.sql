USE gym_records;

DROP EVENT IF EXISTS evt_alerta_socios_sin_plan;

DELIMITER $$

CREATE EVENT evt_alerta_socios_sin_plan
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY + INTERVAL 8 HOUR)
DO
BEGIN
    SELECT 
        s.Socio_ID,
        CONCAT(s.nombre, ' ', s.apellido) AS Nombre_Completo,
        s.Telefono
    FROM SOCIOS s
    LEFT JOIN SOCIO_PLAN_ENTRENAMIENTO spe ON s.Socio_ID = spe.Socio_ID
    WHERE spe.Plan_ID IS NULL;
END$$

DELIMITER ;