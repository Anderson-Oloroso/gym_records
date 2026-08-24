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

---

## 🛑 4. Reglas de Negocio e Implementaciones Técnicas

### 🔄 Bucles y Estructuras de Control
1. **WHILE:** Implementar un procedimiento (`sp_poblacion_socios_while`) para la carga secuencial masiva de socios sintéticos mediante iteraciones `WHILE`.
2. **REPEAT:** Utilizar una estructura de iteración garantizada `REPEAT ... UNTIL` (`sp_poblacion_especialidades_repeat`) para la inserción masiva de especialidades de entrenadores.
3. **LOOP:** Implementar un bucle explícito con etiqueta y sentencia `LEAVE` (`sp_poblacion_sedes_loop`) para poblar registros de sedes controladamente.
4. **CASE:** Clasificar la condición del socio (`sp_categorizar_socio_case`) evaluando la cantidad de planes contratados (`Sin Plan Activo`, `Socio Estándar`, `Socio Frecuente`, `Socio VIP`) a través de un bloque `CASE`.
5. **MANEJO DE ERRORES (Duplicate Key 1062):** Capturar la excepción de clave duplicada mediante `DECLARE duplicate_key CONDITION FOR 1062` y `CONTINUE HANDLER` (`sp_insertar_socio_seguro`) para evitar detenciones en inserciones de socios.
6. **MANEJO DE ERRORES EN TRANSACCIÓN:** Garantizar la atomicidad en la asignación de planes (`sp_registrar_plan_transaccion`) usando `START TRANSACTION`, `COMMIT`, y un `DECLARE EXIT HANDLER FOR SQLEXCEPTION` que ejecuta un `ROLLBACK` seguro ante fallos de integridad.

### 🔍 Consultas Avanzadas y Gestión de Datos
7. **IN y Subconsultas Anidadas:** Consultar socios activos asociados a sedes de una ciudad específica mediante subconsultas encadenadas con el operador `IN` (`sp_consultar_socios_por_sedes`).
8. **INNER JOIN Multitabla:** Generar reportes consolidados (`sp_reporte_completo_asignaciones`) realizando cruces relacionales entre `SOCIO_PLAN_ENTRENAMIENTO`, `SOCIOS`, `PLANES_ENTRENAMIENTO`, `ENTRENADORES`, `ESPECIALIDAD_ENTRENADORES`, `SEDES` y `CIUDADES`.
9. **PARÁMETROS OUT:** Implementar procedimientos almacenados que retornen métricas agregadas de la base de datos a través de variables de salida (`sp_contar_socios_out`).
10. **PARÁMETROS INOUT:** Procesar y acumular contadores de asignaciones de manera bidireccional mediante parámetros mixtos (`sp_acumular_total_asignaciones`) respaldados por `COALESCE`.
11. **IF_THEN_ELSE:** Evaluar el nivel de ocupación u operatividad de una sede (`sp_evaluar_capacidad_sede`) asignando etiquetas cualitativas mediante condicionales `IF ... ELSEIF ... ELSE`.
12. **Optimizaciones de Agrupación:** Consultas optimizadas con `GROUP BY` e `INNER JOIN` (`sp_resumen_socios_activos`) para consolidar totales por socio utilizando la UDF `fn_obtener_nombre_completo`.

### ⏱️ Eventos y Triggers
13. **EVENTO (Reporte Diario):** Programar un evento automático (`EVERY 1 DAY`) que genere y almacene en una tabla de auditoría el conteo diario de socios asignados por cada entrenador.
14. **TRIGGER (Verificación de Disponibilidad):** Crear un disparador `BEFORE INSERT` sobre `SOCIO_PLAN_ENTRENAMIENTO` que verifique que el entrenador no supere el límite máximo permitido de socios activos (ej. máximo 15 socios por entrenador).

### 📐 Funciones Creadas por Usuarios (UDF)
15. **Función Simple:** Reutilizar funciones personalizadas (como `fn_obtener_nombre_completo`) para la concatenación estandarizada de `nombre` y `apellido` de los socios en reportes.
16. **Calcular Comisión Entrenador:** Función que calcula el bono económico del entrenador basado en la cantidad de planes activos bajo su tutela.
17. **Funciones con Condiciones:** Evaluar el estado de cobertura geográfica de una sede según el número de entrenadores asignados mediante bloques `IF/ELSE`.
18. **Funciones con Bucles e Itinerancias:** Calcular mediante iteración interna promedios ponderados de permanencia de los socios.
19. **Funciones que Acceden a Datos:** Consultar directamente las tablas del sistema para retornar el nombre del plan más popular dentro de una sede específica.
20. **Funciones No Determinísticas:** Generar códigos de ticket o referencias temporales de asistencia combinando `UUID()`, `NOW()` y el `Socio_ID`.
21. **Funciones con Manejo de Errores:** Retornar `-1` o un mensaje controlado mediante un `CONTINUE HANDLER FOR SQLEXCEPTION` cuando una consulta interna no encuentre datos.

### 🛠️ Particionamiento y Dinamismo SQL
22. **Particionamiento de Tablas:** Aplicar particionamiento horizontal (`RANGE` o `LIST`) sobre la tabla de transacciones `SOCIO_PLAN_ENTRENAMIENTO` por bloques de `Plan_ID` o rango regional de sedes para acelerar las lecturas en volúmenes masivos.
23. **Consultas Dinámicas (PREPARE, EXECUTE, DEALLOCATE):** Construir procedimientos almacenados (`sp_ejecutar_consulta_dinamica_socio`) para la ejecución segura y parametrizada de sentencias SQL preparadas en tiempo de ejecución.

### 🔐 Seguridad y Creación de Usuarios
24. **CREAR USUARIO:** Registrar cuenta estándar para el personal de recepción (`CREATE USER 'recep_gym'@'localhost' IDENTIFIED BY '...';`).
25. **ASIGNAMOS PERMISOS:** Otorgar permisos globales de lectura e inserción (`GRANT SELECT, INSERT ON gym_records.* TO ...`).
26. **VER PRIVILEGIOS DE UN USUARIO:** Ejecutar `SHOW GRANTS FOR 'recep_gym'@'localhost';` para auditoría de roles.
27. **CREACIÓN DE UN USUARIO ADMIN:** Definir el usuario administrador principal con privilegios totales de estructura y control (`GRANT ALL PRIVILEGES`).
28. **ASIGNAR PERMISOS ESPECÍFICOS SOBRE UNA TABLA:** Restringir el acceso de modificación únicamente a la tabla `SOCIOS` para el rol de atención al cliente.
29. **PRIVILEGIOS SOBRE COLUMNAS:** Conceder permisos de lectura exclusivos sobre las columnas `nombre`, `apellido` y `Telefono` de la tabla `SOCIOS`, restringiendo el acceso a claves primarias o campos de auditoría sensibles.

---

## 📌 Supuestos de Negocio
* **Sistemas de Identificación:** El campo `Socio_ID` utiliza valores numéricos enteros únicos correlativos.
* **Formato de Contacto:** Los números de teléfono consideran el estándar local de Guatemala (8 dígitos), con prefijos opcionales de código de país (+502).
* **Nomenclatura Geográfica:** Los datos de prueba y sedes de la base de datos están orientados a la República de Guatemala (ej. Ciudad_ID: 'GT-01', Gimnasio_Sede: 'Sede Zona 10 - Oakland').
* **Sedes y Cobertura:** Cada sede debe estar vinculada obligatoriamente a una ciudad existente antes de ser registrada.
* **Capacidad Operativa:** Un entrenador solo puede pertenecer a una especialidad principal a la vez para mantener el control estricto de asignaciones dentro de `SOCIO_PLAN_ENTRENAMIENTO`.
* **Motor de Almacenamiento:** Se utiliza el motor `InnoDB` en todas las tablas para garantizar soporte completo a transacciones ACID y restricciones de clave foránea (`FOREIGN KEY`).