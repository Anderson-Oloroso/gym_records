-- =======================================================================
-- CRUD SOCIOS
-- =======================================================================

DELIMITER //
CREATE PROCEDURE agregar_socio(
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_telefono VARCHAR(20),
    OUT p_mensaje VARCHAR(100)
)
BEGIN
-- IF existe
	IF EXISTS (SELECT * FROM SOCIOS WHERE Socio_ID = p_id) THEN
    
		SET p_mensaje = 'Error: El socio ya existe'; 
	ELSE
		
        INSERT INTO SOCIOS (Socio_ID, nombre, apellido, Telefono)
			VALUES (p_id, p_nombre, p_apellido, p_telefono);
            
		SET p_mensaje = '¡ Socio guardado exitosamente !';

	END IF;
    
END //

DELIMITER ;

CALL agregar_socio(201, 'Carlos', 'Pérez', '555-1111', @resultado);

SELECT @resultado AS Respuesta;

DELIMITER //

CREATE PROCEDURE actualizar_telefono_socio(
    IN p_id INT,
    IN p_nuevo_telefono VARCHAR(20),
    OUT p_mensaje VARCHAR(100)
)
BEGIN
    -- NO existe
    IF NOT EXISTS (SELECT * FROM SOCIOS WHERE Socio_ID = p_id) THEN
        
        SET p_mensaje = 'Error: No se encontró ningún socio con ese ID';
        
    ELSE
        
        -- Si existe
        UPDATE SOCIOS 
        SET Telefono = p_nuevo_telefono
        WHERE Socio_ID = p_id;
        
        SET p_mensaje = '¡Teléfono actualizado correctamente!';
        
    END IF;
END //

DELIMITER ;

CALL actualizar_telefono_socio(999, '555-0000', @respuesta);
SELECT @respuesta;

CALL actualizar_telefono_socio(201, '555-9999', @respuesta);
SELECT @respuesta;

USE gym_records;

DROP PROCEDURE IF EXISTS consultar_socio;

DELIMITER //

CREATE PROCEDURE consultar_socio(
    IN p_id INT -- Si enviamos NULL o 0, trae todos. Si enviamos un ID, trae solo ese.
)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        
        -- Trae TODOS los socios
        SELECT Socio_ID, nombre, apellido, Telefono 
        FROM SOCIOS;
        
    ELSE
        
        -- Trae SOLO al socio solicitado
        SELECT Socio_ID, nombre, apellido, Telefono 
        FROM SOCIOS 
        WHERE Socio_ID = p_id;
        
    END IF;
END //

DELIMITER ;

CALL consultar_socio(102);
CALL consultar_socio(NULL);

DELIMITER //

CREATE PROCEDURE eliminar_socio(
    IN p_id INT,
    OUT p_mensaje VARCHAR(120)
)
BEGIN
    -- 1. Validar si el socio NO existe
    IF NOT EXISTS (SELECT 1 FROM SOCIOS WHERE Socio_ID = p_id) THEN
        
        SET p_mensaje = 'Error: No existe ningún socio con el ID proporcionado.';

    -- 2. Validar si tiene relación
    ELSEIF EXISTS (SELECT 1 FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Socio_ID = p_id) THEN
        
        SET p_mensaje = 'Error: No se puede eliminar. El socio tiene planes de entrenamiento asociados.';

    -- 3. Si todo está libre, procedemos a borrar
    ELSE
        
        DELETE FROM SOCIOS WHERE Socio_ID = p_id;
        SET p_mensaje = '¡Socio eliminado correctamente de la base de datos!';

    END IF;
END //

DELIMITER ;

CALL eliminar_socio(101, @respuesta);
SELECT @respuesta AS Resultado;

CALL eliminar_socio(110, @respuesta);
SELECT @respuesta AS Resultado;


-- ========================================================================================
-- CRUD CIUDADES
-- ========================================================================================
DELIMITER //
DROP PROCEDURE IF EXISTS add_city;
CREATE PROCEDURE add_city(IN id_city VARCHAR(10), IN ciudad VARCHAR(100))
BEGIN
	-- IF existe
	IF EXISTS (SELECT * FROM CIUDADES WHERE Ciudad_id = id_city) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar esta ciudad, porque ya existe';
	ELSE
        INSERT INTO ciudades (Ciudad_ID, Ciudad_Sede)
			VALUES (id_city, ciudad);
	END IF;
END//
DELIMITER ;

CALL add_city('C04', 'Sevilla');
SELECT * FROM ciudades;

-- ACttualizar
DROP PROCEDURE IF EXISTS update_city;
DELIMITER //
CREATE PROCEDURE update_city(IN city_id VARCHAR(10),IN name_city VARCHAR(100))
BEGIN 
	-- Si no existe
    IF NOT EXISTS (SELECT * FROM ciudades  WHERE Ciudad_ID = city_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la ciudad no existe';
	ELSE
	-- SI existe
		UPDATE ciudades SET Ciudad_Sede = name_city WHERE Ciudad_ID = city_id;
    END IF;
END//
DELIMITER ;

CALL update_city('C02', 'Toledo');
SELECT * FROM ciudades;

-- Eliminar Ciudad
DROP PROCEDURE IF EXISTS delete_city;
DELIMITER //
CREATE PROCEDURE delete_city(IN city_id VARCHAR(10))
BEGIN
    IF NOT EXISTS (SELECT * FROM ciudades WHERE Ciudad_ID = city_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la ciudad no existe';
	ELSEIF EXISTS (SELECT * FROM SEDES WHERE Ciudad_ID = city_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la ciudad porque tiene sedes registradas';
	ELSE
		DELETE FROM ciudades WHERE Ciudad_ID = city_id;
	END IF;
END//
DELIMITER ;

CALL delete_city('C04');
SELECT * FROM ciudades;

-- Mostrar las ciudades
DROP PROCEDURE IF EXISTS records_city;
DELIMITER //
CREATE PROCEDURE records_city(IN city_id VARCHAR(10)) 
BEGIN
	IF city_id IS NULL OR city_id = '' THEN
        SELECT * FROM ciudades;
    ELSEIF NOT EXISTS (SELECT * FROM ciudades WHERE Ciudad_ID = city_id) THEN
		SELECT * FROM ciudades;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la ciudad no existe';        
	ELSE
		SELECT * FROM ciudades WHERE Ciudad_ID = city_id;
	END IF;
END//

DELIMITER ;

CALL records_city('C06');

-- ========================================================================================
-- CRUD SEDES
-- ========================================================================================

-- Agregar Sede
DROP PROCEDURE IF EXISTS add_sede;
DELIMITER //
CREATE PROCEDURE add_sede(
    IN p_sede_id VARCHAR(10), 
    IN p_nombre VARCHAR(100), 
    IN p_ciudad_id VARCHAR(10)
)
BEGIN
    IF EXISTS (SELECT * FROM SEDES WHERE Sede_ID = p_sede_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar esta sede, porque ya existe';
    ELSEIF NOT EXISTS (SELECT * FROM CIUDADES WHERE Ciudad_ID = p_ciudad_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La ciudad especificada no existe';
    ELSE
        INSERT INTO SEDES (Sede_ID, Gimnasio_Sede, Ciudad_ID)
        VALUES (p_sede_id, p_nombre, p_ciudad_id);
    END IF;
END//
DELIMITER ;

CALL add_sede('S04', 'Sede Este', 'C03');
SELECT * FROM sedes;

-- Actualizar Sede
DROP PROCEDURE IF EXISTS update_sede;
DELIMITER //
CREATE PROCEDURE update_sede(
    IN p_sede_id VARCHAR(10), 
    IN p_nombre VARCHAR(100), 
    IN p_ciudad_id VARCHAR(10)
)
BEGIN
    IF NOT EXISTS (SELECT * FROM SEDES WHERE Sede_ID = p_sede_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la sede no existe';
    ELSEIF NOT EXISTS (SELECT * FROM CIUDADES WHERE Ciudad_ID = p_ciudad_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La ciudad especificada no existe';
    ELSE
        UPDATE SEDES 
        SET Gimnasio_Sede = p_nombre, Ciudad_ID = p_ciudad_id 
        WHERE Sede_ID = p_sede_id;
    END IF;
END//
DELIMITER ;
CALL update_sede('S04', 'Sede Norte', 'C03');
SELECT * FROM sedes;

-- Eliminar Sede
DROP PROCEDURE IF EXISTS delete_sede;
DELIMITER //
CREATE PROCEDURE delete_sede(IN p_sede_id VARCHAR(10))
BEGIN
    IF NOT EXISTS (SELECT * FROM SEDES WHERE Sede_ID = p_sede_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la sede no existe';
    ELSEIF EXISTS (SELECT * FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Sede_ID = p_sede_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la sede porque tiene planes de entrenamiento asociados';
    ELSE
        DELETE FROM SEDES WHERE Sede_ID = p_sede_id;
    END IF;
END//
DELIMITER ;

CALL delete_sede('S04');
SELECT * FROM sedes;

-- Mostrar Sedes
DROP PROCEDURE IF EXISTS records_sede;
DELIMITER //
CREATE PROCEDURE records_sede(IN p_sede_id VARCHAR(10))
BEGIN
    IF p_sede_id IS NULL OR p_sede_id = '' THEN
        SELECT * FROM SEDES;
    ELSEIF NOT EXISTS (SELECT * FROM SEDES WHERE Sede_ID = p_sede_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código de la sede no existe';
    ELSE
        SELECT * FROM SEDES WHERE Sede_ID = p_sede_id;
    END IF;
END//
DELIMITER ;

CALL records_sede(NULL);
CALL records_sede('S03');
-- ========================================================================================
-- CRUD PLANES_ENTRENAMIENTO
-- ========================================================================================

-- Agregar Plan
DROP PROCEDURE IF EXISTS add_plan;
DELIMITER //
CREATE PROCEDURE add_plan(
    IN p_plan_id VARCHAR(10), 
    IN p_nombre VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT * FROM PLANES_ENTRENAMIENTO WHERE Plan_Entrenamiento_ID = p_plan_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar este plan, porque ya existe';
    ELSE
        INSERT INTO PLANES_ENTRENAMIENTO (Plan_Entrenamiento_ID, Plan_Entrenamiento)
        VALUES (p_plan_id, p_nombre);
    END IF;
END//
DELIMITER ;

SELECT * FROM planes_entrenamiento;
CALL add_plan('PE05', 'Calistenia');

-- Actualizar Plan
DROP PROCEDURE IF EXISTS update_plan;
DELIMITER //
CREATE PROCEDURE update_plan(
    IN p_plan_id VARCHAR(10), 
    IN p_nombre VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (SELECT * FROM PLANES_ENTRENAMIENTO WHERE Plan_Entrenamiento_ID = p_plan_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código del plan no existe';
    ELSE
        UPDATE PLANES_ENTRENAMIENTO 
        SET Plan_Entrenamiento = p_nombre 
        WHERE Plan_Entrenamiento_ID = p_plan_id;
    END IF;
END//
DELIMITER ;

CALL update_plan('PE06', 'Calistenia');
SELECT * FROM planes_entrenamiento;

-- Eliminar Plan
DROP PROCEDURE IF EXISTS delete_plan;
DELIMITER //
CREATE PROCEDURE delete_plan(IN p_plan_id VARCHAR(10))
BEGIN
    IF NOT EXISTS (SELECT * FROM PLANES_ENTRENAMIENTO WHERE Plan_Entrenamiento_ID = p_plan_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código del plan no existe';
    ELSEIF EXISTS (SELECT * FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Plan_Entrenamiento_ID = p_plan_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el plan porque hay socios inscritos en él';
    ELSE
        DELETE FROM PLANES_ENTRENAMIENTO WHERE Plan_Entrenamiento_ID = p_plan_id;
    END IF;
END//
DELIMITER ;

CALL delete_plan('PE05');
SELECT * FROM planes_entrenamiento;
