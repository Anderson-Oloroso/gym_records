USE gym_records;

-- TRIGGER: Verificar disponibilidad de entrenador antes de asignación (Máximo 10 socios)
DELIMITER //
CREATE TRIGGER tg_verificar_disponibilidad_entrenador
BEFORE INSERT ON SOCIO_PLAN_ENTRENAMIENTO
FOR EACH ROW
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_cantidad
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = NEW.Entrenador_ID;
    
    IF v_cantidad >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El entrenador seleccionado ha alcanzado el límite máximo de asignaciones (10 socios).';
    END IF;
END //
DELIMITER ;