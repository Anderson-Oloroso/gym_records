USE gym_records;

-- Activar Event Scheduler
SET GLOBAL event_scheduler = ON;

-- EVENTO: Reporte diario - Cantidad de socios por entrenador
CREATE EVENT IF NOT EXISTS evt_reporte_diario_socios_entrenador
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY + INTERVAL 23 HOUR)
DO
    SELECT 
        NOW() AS Fecha_Calculo,
        e.Entrenador_ID,
        e.Nombre_Entrenador,
        COUNT(spe.Socio_ID) AS Total_Socios_Asignados
    FROM ENTRENADORES e
    LEFT JOIN SOCIO_PLAN_ENTRENAMIENTO spe ON e.Entrenador_ID = spe.Entrenador_ID
    GROUP BY e.Entrenador_ID, e.Nombre_Entrenador;