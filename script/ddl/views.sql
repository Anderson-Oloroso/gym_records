USE gym_records;

-- VISTA: Resumen general de asignaciones de socios y sedes
CREATE OR REPLACE VIEW vw_resumen_asignaciones AS
SELECT 
    spe.Plan_ID,
    CONCAT(s.nombre, ' ', s.apellido) AS NombreSocio,
    pe.Plan_Entrenamiento,
    e.Nombre_Entrenador,
    ee.Nombre_Especialidad,
    se.Gimnasio_Sede,
    c.Ciudad_Sede
FROM SOCIO_PLAN_ENTRENAMIENTO spe
INNER JOIN SOCIOS s ON spe.Socio_ID = s.Socio_ID
INNER JOIN PLANES_ENTRENAMIENTO pe ON spe.Plan_Entrenamiento_ID = pe.Plan_Entrenamiento_ID
INNER JOIN ENTRENADORES e ON spe.Entrenador_ID = e.Entrenador_ID
INNER JOIN ESPECIALIDAD_ENTRENADORES ee ON e.Especialidad_ID = ee.Especialidad_ID
INNER JOIN SEDES se ON spe.Sede_ID = se.Sede_ID
INNER JOIN CIUDADES c ON se.Ciudad_ID = c.Ciudad_ID;

