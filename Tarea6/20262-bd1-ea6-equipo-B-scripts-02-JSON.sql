--
-- Scripts - Enunciados DML para Manipulación de Datos Semi-Estructurados (JSON)
-- Manipulación de Campo JSON (Perfil Profesional y Competencias)
--

UPDATE perfil
SET perfil_extra = '{
    "resumen_profesional": "Estudiante de Ingenieria en Desarrollo de Software con conocimientos en programacion y bases de datos.",

    "skills": [
        "C++",
        "SQL",
        "PostgreSQL",
        "Programacion estructurada",
        "Modelado de bases de datos"
    ],

    "areas_interes": [
        "Desarrollo de software",
        "Inteligencia artificial",
        "Bases de datos",
        "Ciberseguridad"
    ],

    "idiomas": [
        {
            "idioma": "Espanol",
            "nivel": "Nativo"
        },
        {
            "idioma": "Ingles",
            "nivel": "Intermedio"
        }
    ],

    "proyectos_destacados": [
        {
            "nombre": "Sistema de inventario",
            "descripcion": "Aplicacion para gestionar productos, cantidades y precios.",
            "tecnologia": "C++"
        },
        {
            "nombre": "Base de datos academica",
            "descripcion": "Diseno y estructuracion de una base de datos relacional.",
            "tecnologia": "PostgreSQL"
        }
    ]
}'::JSONB
WHERE id_perfil = 1;


-- 2. CONSULTAR INFORMACION ESPECIFICA DEL DOCUMENTO JSON

SELECT
    id_perfil,
    perfil_extra ->> 'resumen_profesional' AS resumen_profesional,
    perfil_extra -> 'skills' AS habilidades,
    perfil_extra -> 'areas_interes' AS areas_interes,
    perfil_extra -> 'idiomas' AS idiomas,
    perfil_extra -> 'proyectos_destacados' AS proyectos_destacados
FROM perfil
WHERE id_perfil = 1;


-- A. CONSULTAR INDIVIDUALMENTE LAS HABILIDADES

SELECT
    id_perfil,
    jsonb_array_elements_text(
        perfil_extra -> 'skills'
    ) AS habilidad
FROM perfil
WHERE id_perfil = 1;


-- B. CONSULTAR LOS PROYECTOS DESTACADOS

SELECT
    id_perfil,
    proyecto ->> 'nombre' AS nombre_proyecto,
    proyecto ->> 'descripcion' AS descripcion,
    proyecto ->> 'tecnologia' AS tecnologia
FROM perfil,
LATERAL jsonb_array_elements(
    perfil_extra -> 'proyectos_destacados'
) AS proyecto
WHERE id_perfil = 1;