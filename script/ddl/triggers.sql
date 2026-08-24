USE gym_records;

DROP TRIGGER IF EXISTS tg_verificar_disponibilidad_entrenador;

DELIMITER //

CREATE TRIGGER tg_verificar_disponibilidad_entrenador
BEFORE INSERT ON SOCIO_PLAN_ENTRENAMIENTO
FOR EACH ROW
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    DECLARE v_especialidad_entrenador VARCHAR(10);
    DECLARE v_especialidad_plan VARCHAR(10);
    
    SELECT COUNT(*) INTO v_cantidad
    FROM SOCIO_PLAN_ENTRENAMIENTO
    WHERE Entrenador_ID = NEW.Entrenador_ID;
    
    IF v_cantidad >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El entrenador seleccionado ha alcanzado el límite máximo de asignaciones (10 socios).';
    END IF;

    SELECT Especialidad_ID INTO v_especialidad_entrenador
    FROM ENTRENADORES
    WHERE Entrenador_ID = NEW.Entrenador_ID;

    SELECT p.Plan_Entrenamiento_ID INTO v_especialidad_plan
    FROM PLANES_ENTRENAMIENTO p
    INNER JOIN ESPECIALIDAD_ENTRENADORES e ON e.Nombre_Especialidad = p.Plan_Entrenamiento
    WHERE p.Plan_Entrenamiento_ID = NEW.Plan_Entrenamiento_ID;

    IF v_especialidad_entrenador != v_especialidad_plan THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La especialidad del entrenador no coincide con el plan de entrenamiento seleccionado.';
    END IF;
END //

DELIMITER ;