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

-- ========================================================================
-- CRUD CIUDADES
-- ========================================================================


DELIMITER //
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
