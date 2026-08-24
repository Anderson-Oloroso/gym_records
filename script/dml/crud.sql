USE gym_records;
DELIMITER //

CREATE PROCEDURE agregar_socio(IN p_id INT, IN p_nombre VARCHAR(50), IN p_apellido VARCHAR(50), IN p_telefono VARCHAR(20), OUT p_mensaje VARCHAR(100))
BEGIN
    IF EXISTS (SELECT 1 FROM SOCIOS WHERE Socio_ID = p_id) THEN
        SET p_mensaje = 'Error: El socio ya existe'; 
    ELSE
        INSERT INTO SOCIOS (Socio_ID, nombre, apellido, Telefono)
        VALUES (p_id, p_nombre, p_apellido, p_telefono);
        SET p_mensaje = '¡Socio guardado exitosamente!';
    END IF;
END //

CREATE PROCEDURE actualizar_telefono_socio(IN p_id INT, IN p_nuevo_telefono VARCHAR(20), OUT p_mensaje VARCHAR(100))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SOCIOS WHERE Socio_ID = p_id) THEN
        SET p_mensaje = 'Error: No se encontró ningún socio con ese ID';
    ELSE
        UPDATE SOCIOS SET Telefono = p_nuevo_telefono WHERE Socio_ID = p_id;
        SET p_mensaje = '¡Teléfono actualizado correctamente!';
    END IF;
END //

CREATE PROCEDURE consultar_socio(IN p_id INT)
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        SELECT Socio_ID, nombre, apellido, Telefono 
        FROM SOCIOS;
    ELSE
        SELECT Socio_ID, nombre, apellido, Telefono 
        FROM SOCIOS 
        WHERE Socio_ID = p_id;
    END IF;
END //

CREATE PROCEDURE eliminar_socio(IN p_id INT, OUT p_mensaje VARCHAR(120))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM SOCIOS WHERE Socio_ID = p_id) THEN
        SET p_mensaje = 'Error: No existe ningún socio con el ID proporcionado.';
    ELSEIF EXISTS (SELECT 1 FROM SOCIO_PLAN_ENTRENAMIENTO WHERE Socio_ID = p_id) THEN
        SET p_mensaje = 'Error: No se puede eliminar. El socio tiene planes de entrenamiento asociados.';
    ELSE
        DELETE FROM SOCIOS WHERE Socio_ID = p_id;
        SET p_mensaje = '¡Socio eliminado correctamente de la base de datos!';
    END IF;
END //

CREATE PROCEDURE add_city(IN id_city VARCHAR(10), IN ciudad VARCHAR(100))
BEGIN
    IF EXISTS (SELECT 1 FROM CIUDADES WHERE Ciudad_ID = id_city) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede agregar esta ciudad porque ya existe';
    ELSE
        INSERT INTO CIUDADES (Ciudad_ID, Ciudad_Sede)
        VALUES (id_city, ciudad);
    END IF;
END //
DELIMITER ;