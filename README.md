# Gym Records - Sistema de Gestión de Base de Datos 🏋️‍♂️

> Este sistema consiste en una solución integral de base de datos relacional desarrollada sobre **MySQL**, diseñada para administrar las operaciones, el personal, los socios y el historial transaccional de una cadena de gimnasios.

> El proyecto abarca desde el modelado físico de datos (DDL) y la inserción de datos (DML) hasta lógica avanzada programada mediante DDL/DML extra (funciones, procedimientos, triggers, eventos) y el control de accesos (DCL).

---

## 📂 Estructura del Proyecto

A continuación se presenta la arquitectura de carpetas y archivos que componen el repositorio:

```text
gym\_records/
├── analysis/
│   └── requirements.md         # Análisis detallado de requerimientos, entidades y reglas de negocio.
├── diagrams/
│   └── wkb_gym_records.svg    # Diagrama Entidad-Relación / Modelo Físico en formato SVG.
├── script/
│   ├── dcl/
│   │   └── users.sql           # Creación de usuarios, asignación de roles y privilegios de columna.
│   ├── ddl/
│   │   ├── .gitkeep
│   │   ├── events.sql          # Definición de eventos programados.
│   │   ├── functions.sql       # Funciones definidas por el usuario.
│   │   ├── schema.sql          # Creación de la base de datos, tablas relacionales.
│   │   ├── triggers.sql        # Triggers de auditoría y verificación de capacidad/disponibilidad.
│   │   └── views.sql           # Vistas analíticas y de consulta frecuente.
│   ├── dml/
│   │   ├── .gitkeep
│   │   ├── crud.sql            # Sentencias DML básicas (INSERT, UPDATE, DELETE).
│   │   ├── procedures.sql      # Procedimientos almacenados (control de transacciones, bucles, dinámicos).
│   │   └── script.sql         # Script principal de inserción masiva y carga de datos iniciales.
│   └── dql/
│       ├── .gitkeep
│       └── query.sql           # Consultas avanzadas (JOINs, GROUP BY, subconsultas, IN, CASE).
└── README.md                   # Documentación general y guía principal del proyecto.
```

## 🛠️ Tecnologías y Herramientas

- **Motor de Base de Datos:** MySQL 8.0+
- **Motor de Almacenamiento:** InnoDB
- **Lenguaje:** SQL (DDL, DML, DQL, DCL)
- **Modelado y Diagramación:** MySQL Workbench / SVG Tools
- **Entorno de Desarrollo:** Visual Studio Code

---

## 🗄️ Resumen del Esquema de Datos

El sistema maneja las siguientes entidades clave dentro de la base de datos `gym_records`:

- **SOCIOS:** Registro de clientes del gimnasio.
- **CIUDADES:** Catálogo de ubicaciones geográficas.
- **SEDES:** Sucursales físicas vinculadas a una ciudad.
- **PLANES_ENTRENAMIENTO:** Catálogo de programas de ejercicio.
- **ESPECIALIDAD_ENTRENADORES:** Áreas de dominio del personal técnico.
- **ENTRENADORES:** Personal de instrucción asignado a una especialidad.
- **SOCIO_PLAN_ENTRENAMIENTO:** Tabla transaccional central de asignaciones activas.

---

## ⚡ Características Principales Implementadas

### 🔄 Programación Avanzada (Procedimientos y Bucles)

**Control de Flujo:**
- Implementación de estructuras `WHILE`, `REPEAT`, `LOOP` y `CASE` para iteraciones, clasificaciones de carga de trabajo y procesamiento de datos.

**Manejo de Excepciones:**
- Uso de `DECLARE ... HANDLER FOR SQLEXCEPTION` para control explícito de errores y gestión transaccional con `START TRANSACTION`, `COMMIT` y `ROLLBACK`.

---

### ⏱️ Triggers y Eventos

**Disparadores (Triggers):**
- Control previo (`BEFORE INSERT`) para verificar disponibilidad de entrenadores y asegurar restricciones de negocio antes de registrar un plan.

**Eventos Programados:**
- Eventos diarios (`EVERY 1 DAY`) automatizados para la alerta de socios que no tienen ningun plan.

---

### 📐 Funciones Personalizada

- Cálculo de comisiones para entrenadores.
- Formateo y validación de datos de socios.
- Funciones con acceso a datos, lógica condicional `IF-THEN-ELSE` y manejo no determinístico.

---

### 🔐 Seguridad y Permisos (DCL)

- Roles estructurados para administración y personal de recepción.
- Aplicación de permisos granulares sobre tablas específicas y restricción por columnas:
  - `GRANT SELECT (nombre, apellido) ...`

## Autor
- **Nombre del autor:** `Henrik Anderson Oloroso García`

## Última modificación
- **Fecha:** `24/08/2026`