USE gym_records;

-- 1. FUNCION SIMPLE
DELIMITER //
CREATE FUNCTION fn_obtener_nombre_completo(p_nombre VARCHAR(50), p_apellido VARCHAR(50))
RETURNS VARCHAR(105)
DETERMINISTIC
BEGIN
    RETURN CONCAT(p_apellido, ', ', p_nombre);
END //
DELIMITER ;

-- 2. CALCULAR COMISION ENTRENADOR
DELIMITER //
CREATE FUNCTION fn_calcular_comision_entrenador(p_entrenador_id VARCHAR(10), p_monto_base DECIMAL(10,2))
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total_socios INT DEFAULT 0;
    DECLARE v_comision DECIMAL(10,2) DEFAULT 0;

    SELECT COUNT(*) INTO v_total_socios
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = p_entrenador_id;

    SET v_comision = p_monto_base * (v_total_socios * 0.05);
    RETURN v_comision;
END //
DELIMITER ;

-- 3. FUNCIONES QUE UTILIZAN CONDICIONES
DELIMITER //
CREATE FUNCTION fn_nivel_experiencia_entrenador(p_entrenador_id VARCHAR(10))
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE v_asignaciones INT DEFAULT 0;
    DECLARE v_nivel VARCHAR(30);

    SELECT COUNT(*) INTO v_asignaciones
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = p_entrenador_id;

    IF v_asignaciones > 8 THEN
        SET v_nivel = 'Sénior / Carga Alta';
    ELSEIF v_asignaciones BETWEEN 4 AND 8 THEN
        SET v_nivel = 'Semi-Sénior';
    ELSE
        SET v_nivel = 'Júnior / Carga Baja';
    END IF;

    RETURN v_nivel;
END //
DELIMITER ;

-- 4. FUNCIONES CON BUCLES Y ESTRUCTURAS ITERATIVAS
DELIMITER //
CREATE FUNCTION fn_generar_codigo_seguimiento(p_semilla INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_codigo VARCHAR(50) DEFAULT 'SEC-';

    WHILE i <= p_semilla DO
        SET v_codigo = CONCAT(v_codigo, CHAR(65 + (i % 26)));
        SET i = i + 1;
    END WHILE;

    RETURN v_codigo;
END //
DELIMITER ;

-- 5. FUNCIONES QUE ACCEDEN A DATOS DE LA BASE
DELIMITER //
CREATE FUNCTION fn_obtener_ciudad_sede(p_sede_id VARCHAR(10))
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE v_ciudad_nombre VARCHAR(100);

    SELECT c.Ciudad_Sede INTO v_ciudad_nombre
    FROM SEDES s
    INNER JOIN CIUDADES c ON s.Ciudad_ID = c.Ciudad_ID
    WHERE s.Sede_ID = p_sede_id;

    RETURN IFNULL(v_ciudad_nombre, 'Ciudad No Encontrada');
END //
DELIMITER ;

-- 6. FUNCIONES NO DETERMINISTICAS
DELIMITER //
CREATE FUNCTION fn_generar_ticket_socio(p_socio_id INT)
RETURNS VARCHAR(100)
NOT DETERMINISTIC
BEGIN
    RETURN CONCAT('TK-', p_socio_id, '-', UNIX_TIMESTAMP(), '-', FLOOR(RAND() * 1000));
END //
DELIMITER ;

-- 7. FUNCIONES MANEJO DE ERRORES
DELIMITER //
CREATE FUNCTION fn_obtener_telefono_socio_seguro(p_socio_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE v_telefono VARCHAR(20);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_telefono = 'No Registrado / Inexistente';

    SELECT Telefono INTO v_telefono
    FROM SOCIOS
    WHERE Socio_ID = p_socio_id;

    RETURN v_telefono;
END //
DELIMITER ;