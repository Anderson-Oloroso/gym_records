USE gym_records;

ALTER USER 'operador_gym'@'localhost' IDENTIFIED BY 'Opr_GyM-154_v2!';
GRANT SELECT, INSERT, UPDATE, DELETE ON gym_records.* TO 'operador_gym'@'localhost';

ALTER USER 'admin_gym'@'localhost' IDENTIFIED BY 'AdminGym2026_Secure!';
GRANT ALL PRIVILEGES ON gym_records.* TO 'admin_gym'@'localhost' WITH GRANT OPTION;

ALTER USER 'auditor_sedes'@'localhost' IDENTIFIED BY 'AuditPass456_v2!';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'auditor_sedes'@'localhost';
GRANT SELECT ON gym_records.* TO 'auditor_sedes'@'localhost';

ALTER USER 'recepcion_gym'@'localhost' IDENTIFIED BY 'RecepPass2026!';
GRANT SELECT, INSERT, UPDATE ON gym_records.SOCIOS TO 'recepcion_gym'@'localhost';
GRANT SELECT, INSERT, UPDATE ON gym_records.SOCIO_PLAN_ENTRENAMIENTO TO 'recepcion_gym'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'operador_gym'@'localhost';
SHOW GRANTS FOR 'admin_gym'@'localhost';
SHOW GRANTS FOR 'auditor_sedes'@'localhost';
SHOW GRANTS FOR 'recepcion_gym'@'localhost';