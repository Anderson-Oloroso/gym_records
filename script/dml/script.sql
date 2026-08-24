-- CIUDADES
INSERT INTO CIUDADES (Ciudad_ID, Ciudad_Sede) VALUES
('C01', 'Madrid'),
('C02', 'Barcelona'),
('C03', 'Valencia'),
('C04', 'Sevilla');

-- SEDES
INSERT INTO SEDES (Sede_ID, Gimnasio_Sede, Ciudad_ID) VALUES
('S01', 'Sede Norte', 'C01'),
('S02', 'Sede Sur', 'C01'),
('S03', 'Sede Centro', 'C02'),
('S04', 'Sede Este', 'C03'),
('S05', 'Sede Guadalquivir', 'C04');

-- ESPECIALIDAD_ENTRENADORES
INSERT INTO ESPECIALIDAD_ENTRENADORES (Especialidad_ID, Nombre_Especialidad) VALUES
('EE01', 'Yoga'),
('EE02', 'Musculación'),
('EE03', 'Funcional'),
('EE04', 'Boxeo'),
('EE05', 'Pilates'),
('EE06', 'Spinning');

-- PLANES_ENTRENAMIENTO
INSERT INTO PLANES_ENTRENAMIENTO (Plan_Entrenamiento_ID, Plan_Entrenamiento) VALUES
('PE01', 'Yoga'),
('PE02', 'Pesas'),
('PE03', 'CrossFit'),
('PE04', 'Boxeo'),
('PE05', 'Pilates'),
('PE06', 'Spinning');

-- ENTRENADORES
INSERT INTO ENTRENADORES (Entrenador_ID, Nombre_Entrenador, Especialidad_ID) VALUES
('E01', 'Carlos', 'EE01'),
('E02', 'Marta', 'EE02'),
('E03', 'Iván', 'EE03'),
('E04', 'Diego', 'EE04'),
('E05', 'Laura', 'EE05'),
('E06', 'Pablo', 'EE06');

-- SOCIOS (20 registros en total)
INSERT INTO SOCIOS (Socio_ID, nombre, apellido, Telefono) VALUES
(101, 'Ana', 'Pérez', '555-1234'),
(102, 'Luis', 'Gómez', '555-5678'),
(103, 'Carla', 'Ruíz', '555-9012'),
(104, 'Marcos', 'López', '555-1122'),
(105, 'Elena', 'Torres', '555-3344'),
(106, 'Javier', 'Ramírez', '555-5566'),
(107, 'Sofía', 'Morales', '555-7788'),
(108, 'David', 'Castro', '555-9900'),
(109, 'Laura', 'Navarro', '555-2233'),
(110, 'Gonzalo', 'Blanco', '555-4455'),
(111, 'Lucía', 'Mendoza', '555-6677'),
(112, 'Andrés', 'Vargas', '555-8899'),
(113, 'Valeria', 'Ríos', '555-1212'),
(114, 'Gabriel', 'Ortega', '555-3434'),
(115, 'Camila', 'Delgado', '555-5656'),
(116, 'Mateo', 'Ibáñez', '555-7878'),
(117, 'Natalia', 'Soto', '555-9090'),
(118, 'Alejandro', 'Marín', '555-2323'),
(119, 'Mariana', 'Iglesias', '555-4545'),
(120, 'Tomás', 'Garrido', '555-6767');

-- SOCIO_PLAN_ENTRENAMIENTO (20 registros en total)
INSERT INTO SOCIO_PLAN_ENTRENAMIENTO (Plan_ID, Socio_ID, Plan_Entrenamiento_ID, Entrenador_ID, Sede_ID) VALUES
(1001, 101, 'PE01', 'E01', 'S01'),
(1002, 101, 'PE02', 'E02', 'S01'),
(1003, 102, 'PE03', 'E03', 'S02'),
(1004, 103, 'PE02', 'E02', 'S01'),
(1005, 103, 'PE04', 'E04', 'S01'),
(1006, 104, 'PE01', 'E01', 'S02'),
(1007, 105, 'PE03', 'E03', 'S03'),
(1008, 106, 'PE02', 'E02', 'S02'),
(1009, 107, 'PE04', 'E04', 'S01'),
(1010, 108, 'PE01', 'E01', 'S03'),
(1011, 109, 'PE02', 'E02', 'S03'),
(1012, 110, 'PE03', 'E03', 'S01'),
(1013, 111, 'PE05', 'E05', 'S04'),
(1014, 112, 'PE06', 'E06', 'S05'),
(1015, 113, 'PE01', 'E01', 'S01'),
(1016, 114, 'PE04', 'E04', 'S02'),
(1017, 115, 'PE05', 'E05', 'S03'),
(1018, 116, 'PE02', 'E02', 'S04'),
(1019, 117, 'PE06', 'E06', 'S05'),
(1020, 118, 'PE03', 'E03', 'S02');