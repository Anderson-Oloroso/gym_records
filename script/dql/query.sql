USE gym_records;
DELIMITER //

CREATE PROCEDURE sp_consultar_socios_por_sedes(IN p_ciudad_id VARCHAR(10))
BEGIN
    SELECT * 
    FROM SOCIOS 
    WHERE Socio_ID IN (
        SELECT Socio_ID 
        FROM SOCIO_PLAN_ENTRENAMIENTO 
        WHERE Sede_ID IN (
            SELECT Sede_ID 
            FROM SEDES 
            WHERE Ciudad_ID = p_ciudad_id
        )
    );
END //

CREATE PROCEDURE sp_reporte_completo_asignaciones()
BEGIN
    SELECT 
        spe.Plan_ID,
        fn_obtener_nombre_completo(s.nombre, s.apellido) AS NombreSocio,
        pe.Plan_Entrenamiento,
        e.Nombre_Entrenador,
        ee.Nombre_Especialidad,
        se.Gimnasio_Sede,
        c.Ciudad_Sede
    FROM (((((SOCIO_PLAN_ENTRENAMIENTO spe
    INNER JOIN SOCIOS s ON spe.Socio_ID = s.Socio_ID)
    INNER JOIN PLANES_ENTRENAMIENTO pe ON spe.Plan_Entrenamiento_ID = pe.Plan_Entrenamiento_ID)
    INNER JOIN ENTRENADORES e ON spe.Entrenador_ID = e.Entrenador_ID)
    INNER JOIN ESPECIALIDAD_ENTRENADORES ee ON e.Especialidad_ID = ee.Especialidad_ID)
    INNER JOIN SEDES se ON spe.Sede_ID = se.Sede_ID)
    INNER JOIN CIUDADES c ON se.Ciudad_ID = c.Ciudad_ID;
END //

CREATE PROCEDURE sp_contar_socios_out(OUT p_total_socios INT)
BEGIN
    SELECT COUNT(*) INTO p_total_socios FROM SOCIOS;
END //

CREATE PROCEDURE sp_acumular_total_asignaciones(INOUT p_acumulado INT, IN p_socio_id INT)
BEGIN
    DECLARE v_conteo INT DEFAULT 0;
    SELECT COUNT(*) INTO v_conteo FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Socio_ID = p_socio_id;
    SET p_acumulado = COALESCE(p_acumulado, 0) + v_conteo;
END //

CREATE PROCEDURE sp_resumen_socios_activos()
BEGIN
    SELECT 
        s.Socio_ID,
        fn_obtener_nombre_completo(s.nombre, s.apellido) AS NombreCompleto,
        COUNT(spe.Plan_ID) AS TotalPlanes
    FROM SOCIOS s
    INNER JOIN SOCIO_PLAN_ENTRENAMIENTO spe ON s.Socio_ID = spe.Socio_ID
    GROUP BY s.Socio_ID, s.nombre, s.apellido;
END //

DELIMITER ;