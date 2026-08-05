USE gym_records;

-- Inserción en CIUDADES
INSERT INTO CIUDADES (Ciudad_ID, Ciudad_Sede) VALUES
('C01', 'Madrid'),
('C02', 'Barcelona'),
('C03', 'Valencia');

-- Inserción en SEDES
INSERT INTO SEDES (Sede_ID, Gimnasio_Sede, Ciudad_ID) VALUES
('S01', 'Sede Norte', 'C01'),
('S02', 'Sede Sur', 'C01'),
('S03', 'Sede Centro', 'C02');

-- Inserción en ESPECIALIDAD_ENTRENADORES
INSERT INTO ESPECIALIDAD_ENTRENADORES (Especialidad_ID, Nombre_Especialidad) VALUES
('EE01', 'Yoga'),
('EE02', 'Musculación'),
('EE03', 'Funcional'),
('EE04', 'Boxeo');

-- Inserción en PLANES_ENTRENAMIENTO
INSERT INTO PLANES_ENTRENAMIENTO (Plan_Entrenamiento_ID, Plan_Entrenamiento) VALUES
('PE01', 'Yoga'),
('PE02', 'Pesas'),
('PE03', 'CrossFit'),
('PE04', 'Boxeo');

-- Inserción en ENTRENADORES
INSERT INTO ENTRENADORES (Entrenador_ID, Nombre_Entrenador, Especialidad_ID) VALUES
('E01', 'Carlos', 'EE01'),
('E02', 'Marta', 'EE02'),
('E03', 'Iván', 'EE03'),
('E04', 'Diego', 'EE04');

-- Inserción en SOCIOS (10 registros)
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
(110, 'Gonzalo', 'Blanco', '555-4455');

-- Inserción en SOCIO_PLAN_ENTRENAMIENTO (10 registros)
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
(1010, 108, 'PE01', 'E01', 'S03');