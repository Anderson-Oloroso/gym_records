USE gym_records;

DROP FUNCTION IF EXISTS fn_obtener_nombre_completo;
DROP FUNCTION IF EXISTS fn_calcular_comision_entrenador;
DROP FUNCTION IF EXISTS fn_nivel_experiencia_entrenador;
DROP FUNCTION IF EXISTS fn_generar_codigo_seguimiento;
DROP FUNCTION IF EXISTS fn_obtener_ciudad_sede;
DROP FUNCTION IF EXISTS fn_generar_ticket_socio;
DROP FUNCTION IF EXISTS fn_obtener_telefono_socio_seguro;

DELIMITER //

CREATE FUNCTION fn_obtener_nombre_completo(p_nombre VARCHAR(50), p_apellido VARCHAR(50))
RETURNS VARCHAR(105)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT(UPPER(TRIM(p_apellido)), ', ', TRIM(p_nombre));
END //

CREATE FUNCTION fn_calcular_comision_entrenador(p_entrenador_id VARCHAR(10), p_monto_base DECIMAL(10,2))
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total_socios INT DEFAULT 0;
    
    SELECT COUNT(DISTINCT Socio_ID) INTO v_total_socios
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = p_entrenador_id;

    RETURN ROUND(p_monto_base * (v_total_socios * 0.05), 2);
END //

CREATE FUNCTION fn_nivel_experiencia_entrenador(p_entrenador_id VARCHAR(10))
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE v_asignaciones INT DEFAULT 0;

    SELECT COUNT(*) INTO v_asignaciones
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = p_entrenador_id;

    RETURN CASE 
        WHEN v_asignaciones >= 5 THEN 'Sénior / Carga Alta'
        WHEN v_asignaciones BETWEEN 2 AND 4 THEN 'Semi-Sénior'
        ELSE 'Júnior / Carga Baja'
    END;
END //

CREATE FUNCTION fn_generar_codigo_seguimiento(p_semilla INT)
RETURNS VARCHAR(50)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_codigo VARCHAR(50) DEFAULT 'SEC-';

    WHILE i <= LEAST(GREATEST(p_semilla, 1), 20) DO
        SET v_codigo = CONCAT(v_codigo, CHAR(65 + ((i * 7) % 26)));
        SET i = i + 1;
    END WHILE;

    RETURN v_codigo;
END //

CREATE FUNCTION fn_obtener_ciudad_sede(p_sede_id VARCHAR(10))
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE v_ciudad_nombre VARCHAR(100);

    SELECT c.Ciudad_Sede INTO v_ciudad_nombre
    FROM SEDES s
    INNER JOIN CIUDADES c ON s.Ciudad_ID = c.Ciudad_ID
    WHERE s.Sede_ID = p_sede_id;

    RETURN COALESCE(v_ciudad_nombre, 'Ciudad No Encontrada');
END //

CREATE FUNCTION fn_generar_ticket_socio(p_socio_id INT)
RETURNS VARCHAR(100)
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN CONCAT('TK-', LPAD(p_socio_id, 5, '0'), '-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));
END //

CREATE FUNCTION fn_obtener_telefono_socio_seguro(p_socio_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE v_telefono VARCHAR(20) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_telefono = NULL;

    SELECT Telefono INTO v_telefono
    FROM SOCIOS
    WHERE Socio_ID = p_socio_id;

    RETURN IF(v_telefono IS NULL OR TRIM(v_telefono) = '', 'No Registrado / Inexistente', v_telefono);
END //

DELIMITER ;