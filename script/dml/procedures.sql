USE gym_records;

-- PROCEDIMIENTOS ALMACENADOS PARA OPERACIONES CRUD Y LÓGICA DE NEGOCIO

-- 1. BUCLE WHILE: Población de datos
DELIMITER //
CREATE PROCEDURE sp_poblacion_socios_while(IN p_cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= p_cantidad DO
        INSERT INTO SOCIOS (Socio_ID, nombre, apellido, Telefono)
        VALUES (i, CONCAT('SocioName_', i), CONCAT('SocioLastName_', i), CONCAT('555-000', i));
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- 2. BUCLE REPEAT: Población de especialidades
DELIMITER //
CREATE PROCEDURE sp_poblacion_especialidades_repeat(IN p_limite INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    REPEAT
        INSERT INTO ESPECIALIDAD_ENTRENADORES (Especialidad_ID, Nombre_Especialidad)
        VALUES (CONCAT('ESP', i), CONCAT('Especialidad Nivel ', i));
        SET i = i + 1;
    UNTIL i > p_limite
    END REPEAT;
END //
DELIMITER ;

-- 3. BUCLE LOOP: Población de sedes
DELIMITER //
CREATE PROCEDURE sp_poblacion_sedes_loop(IN p_limite INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    
    mi_loop: LOOP
        IF i > p_limite THEN
            LEAVE mi_loop;
        END IF;

        INSERT INTO SEDES (Sede_ID, Gimnasio_Sede, Ciudad_ID)
        VALUES (CONCAT('SED', i), CONCAT('Sede Central ', i), 'CIU1');

        SET i = i + 1;
    END LOOP mi_loop;
END //
DELIMITER ;

-- 4. CONDICIONAL CASE: Categorizar socio
DELIMITER //
CREATE PROCEDURE sp_categorizar_socio_case(IN p_socio_id INT, OUT p_categoria VARCHAR(50))
BEGIN
    DECLARE v_conteo INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_conteo
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Socio_ID = p_socio_id;
    
    CASE 
        WHEN v_conteo = 0 THEN SET p_categoria = 'Sin Plan Activo';
        WHEN v_conteo = 1 THEN SET p_categoria = 'Socio Estándar';
        WHEN v_conteo BETWEEN 2 AND 3 THEN SET p_categoria = 'Socio Frecuente';
        ELSE SET p_categoria = 'Socio VIP';
    END CASE;
END //
DELIMITER ;

-- 5. MANEJO DE ERRORES: Duplicate Key (1062)
DELIMITER //
CREATE PROCEDURE sp_insertar_socio_seguro(
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE duplicate_key CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR duplicate_key
    BEGIN
        SELECT CONCAT('Error 1062: El Socio_ID ', p_id, ' ya existe en la base de datos.') AS MensajeError;
    END;

    INSERT INTO SOCIOS (Socio_ID, nombre, apellido, Telefono)
    VALUES (p_id, p_nombre, p_apellido, p_telefono);
END //
DELIMITER ;

-- 6. MANEJO DE ERRORES EN TRANSACCIÓN
DELIMITER //
CREATE PROCEDURE sp_registrar_plan_transaccion(
    IN p_plan_id INT,
    IN p_socio_id INT,
    IN p_plan_entrenamiento_id VARCHAR(10),
    IN p_entrenador_id VARCHAR(10),
    IN p_sede_id VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transacción cancelada. Ocurrió un error de integridad de datos.' AS EstadoTransaccion;
    END;

    START TRANSACTION;

    INSERT INTO SOCIO_PLAN_ENTRENAMIENTO (Plan_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID)
    VALUES (p_plan_id, p_socio_id, p_plan_entrenamiento_id, p_entrenador_id, p_sede_id);

    COMMIT;
    SELECT 'Transacción completada exitosamente.' AS EstadoTransaccion;
END //
DELIMITER ;

-- 7. INSERCIÓN DIRECTA VÍA PROCEDURE
DELIMITER //
CREATE PROCEDURE sp_insertar_entrenador(
    IN p_entrenador_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_especialidad_id VARCHAR(10)
)
BEGIN
    INSERT INTO ENTRENADORES (Entrenador_ID, Nombre_Entrenador, Especialidad_ID)
    VALUES (p_entrenador_id, p_nombre, p_especialidad_id);
END //
DELIMITER ;

-- 8. CONDICIONAL IF_THEN_ELSE
DELIMITER //
CREATE PROCEDURE sp_evaluar_capacidad_sede(IN p_sede_id VARCHAR(10), OUT p_estado VARCHAR(50))
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Sede_ID = p_sede_id;

    IF v_total > 50 THEN
        SET p_estado = 'Sede con alta demanda';
    ELSEIF v_total BETWEEN 20 AND 50 THEN
        SET p_estado = 'Sede con demanda moderada';
    ELSE
        SET p_estado = 'Sede con baja demanda';
    END IF;
END //
DELIMITER ;

-- 9. PREPARE, EXECUTE, DEALLOCATE (Sentencias dinámicas)
DELIMITER //
CREATE PROCEDURE sp_ejecutar_consulta_dinamica_socio(IN p_socio_id INT)
BEGIN
    SET @sql = 'SELECT Socio_ID, nombre, apellido, Telefono FROM SOCIOS WHERE Socio_ID = ?';
    SET @id_param = p_socio_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id_param;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;