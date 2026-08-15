# Análisis de Requerimientos y Diseño de Base de Datos - Gym Records 🏋️‍♂️

## 🎯 1. Objetivos del Almacenamiento
Diseñar e implementar una base de datos relacional robusta en MySQL (`gym_records`) para centralizar la gestión operativa de un gimnasio con múltiples sedes y entrenadores. El sistema administrará eficientemente la información de socios, ubicaciones geográficas, sedes, especialidades del personal, entrenadores y asignación de planes de entrenamiento. Asimismo, el entorno incluirá lógica programada (procedimientos almacenados, funciones, triggers y eventos) para automatizar la auditoría, control de disponibilidad, cálculo de comisiones, seguridad de accesos y particionamiento de datos.

---

## 🏢 2. Entidades Detectadas

* **SOCIOS:** Almacena la información de identificación y contacto de los clientes inscritos en el gimnasio.
  * *Datos requeridos:* `Socio_ID` (PK), `nombre`, `apellido`, `Telefono`.

* **CIUDADES:** Mantiene el catálogo de ciudades donde opera la red de gimnasios.
  * *Datos requeridos:* `Ciudad_ID` (PK), `Ciudad_Sede`.

* **SEDES:** Registra las sucursales físicas del gimnasio asociadas a una ciudad específica.
  * *Datos requeridos:* `Sede_ID` (PK), `Gimnasio_Sede`, `Ciudad_ID` (FK).

* **PLANES_ENTRENAMIENTO:** Contiene la oferta de programas de entrenamiento disponibles (ej. Hipertrofia, Pérdida de peso, Funcional).
  * *Datos requeridos:* `Plan_Entrenamiento_ID` (PK), `Plan_Entrenamiento`.

* **ESPECIALIDAD_ENTRENADORES:** Catálogo de áreas de especialización técnica del personal instructor (ej. Musculación, CrossFit, Nutrición Deportiva).
  * *Datos requeridos:* `Especialidad_ID` (PK), `Nombre_Especialidad`.

* **ENTRENADORES:** Registra al personal de instrucción asignado al gimnasio y su especialidad principal.
  * *Datos requeridos:* `Entrenador_ID` (PK), `Nombre_Entrenador`, `Especialidad_ID` (FK).

* **SOCIO_PLAN_ENTRENAMIENTO:** Tabla transaccional central que vincula la asignación de un plan de entrenamiento a un socio, gestionado por un entrenador en una sede determinada.
  * *Datos requeridos:* `Plan_ID` (PK), `Socio_ID` (FK), `Plan_Entrenamiento_ID` (FK), `Entrenador_ID` (FK), `Sede_ID` (FK).

---

## 🔗 3. Relaciones y Cardinalidades

* **CIUDADES - SEDES (1:N):** Una ciudad puede albergar múltiples sedes del gimnasio, pero una sede pertenece a una única ciudad.
* **ESPECIALIDAD_ENTRENADORES - ENTRENADORES (1:N):** Una especialidad puede ser ejercida por varios entrenadores, pero cada entrenador tiene asignada una especialidad base.
* **SOCIOS - SOCIO_PLAN_ENTRENAMIENTO (1:N):** Un socio puede inscribirse en múltiples planes de entrenamiento a lo largo del tiempo, pero cada registro de asignación pertenece a un único socio.
* **PLANES_ENTRENAMIENTO - SOCIO_PLAN_ENTRENAMIENTO (1:N):** Un plan de entrenamiento puede ser asignado a múltiples socios, pero un registro de asignación referencia un solo plan.
* **ENTRENADORES - SOCIO_PLAN_ENTRENAMIENTO (1:N):** Un entrenador puede supervisar a múltiples socios en sus planes, pero un registro de asignación especifica a un único entrenador responsable.
* **SEDES - SOCIO_PLAN_ENTRENAMIENTO (1:N):** Una sede puede ser el escenario de múltiples asignaciones de entrenamiento, pero una asignación se ejecuta en una sola sede.
* **HISTORIAL_ASIGNACIONES:** Tabla de auditoría e historial analítico particionada por rangos de año para consultar registros antiguos de asignación con alto rendimiento.
  * *Datos requeridos:* `Historial_ID` (PK), `Anio_Registro` (PK), `Plan_ID`, `Socio_ID`.

---

## 🛑 4. Reglas de Negocio e Implementaciones Técnicas

### 🔄 Bucles y Estructuras de Control
1. **WHILE:** Implementar un procedimiento de carga masiva sintética o migraciones batch para simular la asignación secuencial de planes de entrenamiento a socios.
2. **REPEAT:** Utilizar una estructura de iteración garantizada para la validación interna del formato telefónico de socios antes de confirmar inserciones masivas.
3. **CASE:** Clasificar a los entrenadores según la cantidad de socios asignados (ej. 'Carga Alta', 'Carga Media', 'Carga Baja') dentro de consultas analíticas.
4. **MANEJO DE ERRORES (Código Específico):** Capturar excepciones explícitas como la duplicación de claves primarias (`SQLSTATE '23000'` / Error `1062`) durante la inserción de nuevos socios.
5. **MANEJO DE ERRORES (Transacción):** Asegurar la atomicidad en la asignación de planes mediante `START TRANSACTION`, `COMMIT` y `ROLLBACK` frente a fallos de integridad referencial.

### 🔍 Consultas Avanzadas y Gestión de Datos
6. **IN:** Filtrar entrenadores o socios pertenecientes a una lista específica de sedes o especialidades (ej. sedes de 'Zona 10', 'Zona 14', 'Carretera al Salvador').
7. **INNER JOIN:** Realizar cruces multitabla entre `SOCIOS`, `SOCIO_PLAN_ENTRENAMIENTO`, `PLANES_ENTRENAMIENTO`, `ENTRENADORES` y `SEDES` para obtener el historial consolidado del cliente.
8. **OUT:** Implementar procedimientos almacenados con parámetros de salida (`OUT`) para retornar contadores de socios activos.
9. **INOUT:** Implementar parámetros mixtos (`INOUT`) para procesar códigos de descuento en inscripciones.
10. **Inserción Transaccional:** Módulo seguro de registro de socios y asignación simultánea de plan utilizando variables de sesión SQL.
11. **IF_THEN_ELSE:** Evaluar si un entrenador posee la especialidad requerida para el plan antes de permitir el registro transaccional en `SOCIO_PLAN_ENTRENAMIENTO`.
12. **LOOP:** Recorrer mediante un cursor la lista de entrenadores para calcular de forma acumulativa su carga de trabajo semanal.
13. **Depuración de Consultas Innecesarias:** Optimizar las sentencias SQL eliminando subconsultas redundantes sobre la tabla `CIUDADES` en favor de joins indexados sobre `SEDES`.

### ⏱️ Eventos y Triggers
14. **EVENTO (Reporte Diario):** Programar un evento automático (`EVERY 1 DAY`) que genere y almacene en una tabla de auditoría el conteo diario de socios asignados por cada entrenador.
15. **TRIGGER (Verificación de Disponibilidad):** Crear un disparador `BEFORE INSERT` sobre `SOCIO_PLAN_ENTRENAMIENTO` que verifique que el entrenador no supere el límite máximo permitido de socios activos (ej. máximo 15 socios por entrenador).

### 📐 Funciones Creadas por Usuarios (UDF)
16. **Función Simple:** Obtener el nombre completo de un socio concatenando `nombre` y `apellido`.
17. **Calcular Comisión Entrenador:** Función que calcula el bono económico del entrenador basado en la cantidad de planes activos bajo su tutela.
18. **Funciones con Condiciones:** Evaluar el estado de cobertura geográfica de una sede según el número de entrenadores asignados mediante bloques `IF/ELSE`.
19. **Funciones con Bucles e Itinerancias:** Calcular mediante iteración interna promedios ponderados de permanencia de los socios.
20. **Funciones que Acceden a Datos:** Consultar directamente las tablas del sistema para retornar el nombre del plan más popular dentro de una sede específica.
21. **Funciones No Determinísticas:** Generar códigos de ticket o referencias temporales de asistencia combinando `UUID()`, `NOW()` y el `Socio_ID`.
22. **Funciones con Manejo de Errores:** Retornar `-1` o un mensaje controlado mediante un `CONTINUE HANDLER FOR SQLEXCEPTION` cuando una consulta interna no encuentre datos.

### 🛠️ Particionamiento y Dinamismo SQL
23. **Particionamiento de Tablas:** Aplicar particionamiento horizontal (`RANGE` o `LIST`) sobre la tabla de transacciones `SOCIO_PLAN_ENTRENAMIENTO` por bloques de `Plan_ID` o rango regional de sedes para acelerar las lecturas en volúmenes masivos.
24. **Consultas Dinámicas (PREPARE, EXECUTE, DEALLOCATE):** Construir procedimientos almacenados para la búsqueda flexible de socios según criterios dinámicos filtrados en tiempo de ejecución.

### 🔐 Seguridad y Creación de Usuarios
25. **CREAR USUARIO:** Registrar cuenta estándar para el personal de recepción (`CREATE USER 'recep_gym'@'localhost' IDENTIFIED BY '...';`).
26. **ASIGNAMOS PERMISOS:** Otorgar permisos globales de lectura e inserción (`GRANT SELECT, INSERT ON gym_records.* TO ...`).
27. **VER PRIVILEGIOS DE UN USUARIO:** Ejecutar `SHOW GRANTS FOR 'recep_gym'@'localhost';` para auditoría de roles.
28. **CREACIÓN DE UN USUARIO ADMIN:** Definir el usuario administrador principal con privilegios totales de estructura y control (`GRANT ALL PRIVILEGES`).
29. **ASIGNAR PERMISOS ESPECÍFICOS SOBRE UNA TABLA:** Restringir el acceso de modificación únicamente a la tabla `SOCIOS` para el rol de atención al cliente.
30. **PRIVILEGIOS SOBRE COLUMNAS:** Conceder permisos de lectura exclusivos sobre las columnas `nombre`, `apellido` y `Telefono` de la tabla `SOCIOS`, restringiendo el acceso a claves primarias o campos de auditoría sensibles.

---

## 📌 Supuestos de Negocio
* **Sistemas de Identificación:** El campo `Socio_ID` utiliza valores numéricos enteros únicos correlativos.
* **Formato de Contacto:** Los números de teléfono consideran el estándar local de Guatemala (8 dígitos), con prefijos opcionales de código de país (+502).
* **Nomenclatura Geográfica:** Los datos de prueba y sedes de la base de datos están orientados a la República de Guatemala (ej. Ciudad_ID: 'GT-01', Gimnasio_Sede: 'Sede Zona 10 - Oakland').
* **Sedes y Cobertura:** Cada sede debe estar vinculada obligatoriamente a una ciudad existente antes de ser registrada.
* **Capacidad Operativa:** Un entrenador solo puede pertenecer a una especialidad principal a la vez para mantener el control estricto de asignaciones dentro de `SOCIO_PLAN_ENTRENAMIENTO`.
* **Motor de Almacenamiento:** Se utiliza el motor `InnoDB` en todas las tablas para garantizar soporte completo a transacciones ACID y restricciones de clave foránea (`FOREIGN KEY`).