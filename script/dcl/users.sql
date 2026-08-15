USE gym_records;

-- Crear usuario operador
CREATE USER IF NOT EXISTS 'operador_gym'@'localhost' IDENTIFIED BY 'Opr_GyM-154';
GRANT SELECT, INSERT, UPDATE ON gym_records.* TO 'operador_gym'@'localhost';
SHOW GRANTS FOR 'operador_gym'@'localhost';

-- Crear usuario administrador
CREATE USER IF NOT EXISTS 'admin_gym'@'localhost' IDENTIFIED BY 'AdminGym2026!';
GRANT ALL PRIVILEGES ON gym_records.* TO 'admin_gym'@'localhost' WITH GRANT OPTION;

-- Create usuario auditor
CREATE USER IF NOT EXISTS 'auditor_sedes'@'localhost' IDENTIFIED BY 'AuditPass456!';
GRANT SELECT ON gym_records.SEDES TO 'auditor_sedes'@'localhost';

-- Crear usuario recepcion
CREATE USER IF NOT EXISTS 'recepcion_gym'@'localhost' IDENTIFIED BY 'RecepPass';
GRANT SELECT, UPDATE ON gym_records.SOCIOS TO 'recepcion_gym'@'localhost';

FLUSH PRIVILEGES;
