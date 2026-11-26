--
-- Script Poblamiento
--

--
-- 1.1- Poblamiento Directo mediante INSERT INTO (Catálogos Base):
--

INSERT INTO rol (id_rol, nombre, descripcion) VALUES
(1, 'Administrador', 'Control total del sistema y gestión de usuarios'),
(2, 'Auxiliar', 'Apoya la administración y moderación de contenidos'),
(3, 'Miembro', 'Usuario registrado con acceso completo a las funcionalidades'),
(4, 'Visitante', 'Usuario con acceso limitado de solo consulta');

INSERT INTO tipo_usuario (id_tipo_usuario, nombre, descripcion) VALUES
(1, 'Estudiante', 'Persona matriculada actualmente en la institución'),
(2, 'Docente', 'Profesor vinculado actualmente a la institución'),
(3, 'Egresado', 'Persona que culminó sus estudios en la institución'),
(4, 'Empleado', 'Personal administrativo o de apoyo vinculado actualmente'),
(5, 'Empresario', 'Persona con empresa o emprendimiento propio'),
(6, 'Ex-Empleado', 'Persona que estuvo vinculada como empleado'),
(7, 'Ex-Estudiante', 'Persona que estuvo matriculada y no culminó sus estudios'),
(8, 'Ex-Docente', 'Persona que estuvo vinculada como docente'),
(9, 'Guess', 'Invitado externo a la comunidad institucional');

INSERT INTO tipo_servicio (id_tipo_servicio, nombre, descripcion) VALUES
(1, 'Asesoría académica', 'Tutorías y apoyo en asignaturas'),
(2, 'Clases de idiomas', 'Enseñanza de idiomas'),
(3, 'Curso Tecnológico', 'Creación de aplicaciones y sitios web, IOT y big data'),
(4, 'Mantenimiento Moto', 'Reparación y mantenimiento de motocicletas'),
(5, 'Reparación artículo electrónico', 'Mantenimiento y reparación de variados tipos de aparatos eléctricos'),
(6, 'Corte de cabello', 'Servicios de corte y cuidado del cabello'),
(7, 'Camarógrafo', 'Servicio de fotografía y video'),
(8, 'Reparación PC', 'Reparación y soporte de equipos de cómputo'),
(9, 'Mensaje terapéutico', 'Entrega de documentos y paquetes'),
(10, 'Declaración de impuestos', 'Orientación legal básica para declarar'),
(11, 'Asesoría Trabajo de Grado', 'Apoyo en asuntos relacionados con trabajos de grado'),
(12, 'Entrenamiento deportivo', 'Preparación física y deportiva'),
(13, 'Transporte', 'Servicio de transporte de personas'),
(14, 'Elaboración de Dulces', 'Preparación de postres y comidas dulces'),
(15, 'Limpieza', 'Servicios de aseo y limpieza'),
(16, 'Confección vestimenta', 'Diseño y creación de prendas de ropa'),
(17, 'Organización evento', 'Logística y personal para eventos'),
(18, 'Traducción', 'Traducción de documentos y textos'),
(19, 'Cuidado de mascotas', 'Paseo y cuidado de mascotas'),
(20, 'Otros servicios', 'Servicios no clasificados en otra categoría');

INSERT INTO tipo_producto (id_tipo_producto, nombre, descripcion) VALUES
(1, 'Libro', 'Textos académicos y de lecturas varias'),
(2, 'Motocicleta', 'Motocicletas nuevas y usadas'),
(3, 'Ticket de Concierto', 'Boletas y reservas para conciertos'),
(4, 'Ropa', 'Prendas de vestir'),
(5, 'Calzado', 'Zapatos y zapatillas'),
(6, 'Postres', 'Dispositivos y accesorios electrónicos'),
(7, 'Alimento', 'Almuerzos, desayunos, refrigerio, bebidas, entre otros'),
(8, 'Celular', 'Teléfonos móviles y accesorios'),
(9, 'Mueble', 'Muebles para hogar y oficina'),
(10, 'Electrodoméstico', 'Aparatos para el hogar'),
(11, 'Bicicleta', 'Bicicletas y accesorios'),
(12, 'Papelería', 'Útiles escolares y de oficina'),
(13, 'Instrumento musical', 'Instrumentos y accesorios musicales'),
(14, 'Artículo deportivo', 'Implementos para práctica deportiva'),
(15, 'Computador', 'Portátiles, de escritorio, periféricos y relacionados'),
(16, 'Herramienta', 'Herramientas manuales'),
(17, 'Accesorio', 'Bolsos, relojes, joyería y similares'),
(18, 'Artesanía', 'Productos hechos a mano'),
(19, 'Repuesto', 'Repuestos para vehículos y equipos'),
(20, 'Otros productos', 'Productos no clasificados en otra categoría');

INSERT INTO tipo_evento (id_tipo_evento, nombre, descripcion) VALUES
(1, 'Congreso', 'Encuentros académicos o profesionales de gran escala'),
(2, 'Conferencia', 'Charlas magistrales sobre un tema específico'),
(3, 'Taller', 'Sesiones prácticas de aprendizaje'),
(4, 'Seminario', 'Reuniones de estudio y debate sobre un tema'),
(5, 'Simposio', 'Encuentros de especialistas para discutir un tema'),
(6, 'Foro', 'Espacios de discusión abierta'),
(7, 'Curso', 'Programas de formación de corta duración'),
(8, 'Feria', 'Exposición y venta de productos o proyectos'),
(9, 'Exposición', 'Muestras de arte, ciencia o proyectos'),
(10, 'Concurso', 'Competencias académicas, culturales o deportivas'),
(11, 'Torneo deportivo', 'Competencias deportivas'),
(12, 'Evento cultural', 'Actividades artísticas y culturales'),
(13, 'Concierto', 'Presentaciones musicales'),
(14, 'Obra de teatro', 'Presentaciones teatrales'),
(15, 'Ceremonia de grado', 'Actos de graduación'),
(16, 'Reunion grupo interés', 'Encuentros de trabajo o coordinación'),
(17, 'Jornadas de voluntariado', 'Actividades de servicio social'),
(18, 'Charla', 'Presentaciones informales sobre un tema'),
(19, 'Rueda de negocio', 'Encuentros para generar contactos comerciales'),
(20, 'Otros eventos', 'Eventos no clasificados en otra categoría');

--
-- 1.2- Poblamiento Masivo Automatizado (Generadores Aleatorios):
--

CREATE TEMP TABLE tmp_tipo AS
SELECT n,
       CASE WHEN n <= 7000  THEN 1
            WHEN n <= 7500  THEN 2
            WHEN n <= 17500 THEN 3
            WHEN n <= 18000 THEN 4
            WHEN n <= 18050 THEN 5
            WHEN n <= 18100 THEN 6
            WHEN n <= 18400 THEN 7
            WHEN n <= 18500 THEN 8
            ELSE 9
       END AS tipo
FROM generate_series(1, 18550) AS n;

INSERT INTO usuario (id_rol, nombre_1, nombre_2, apellido_1, apellido_2,
                     fecha_nac, sexo, correo, contrasena, telefono, fecha_registro)
SELECT

    CASE WHEN g.tipo = 4 AND g.n % 100 = 0 THEN 1
         WHEN g.tipo = 4 AND g.n % 10  = 0 THEN 2
         WHEN g.tipo = 9 THEN 4
         ELSE 3 END,
    g.nombre_1,
    CASE WHEN g.tiene_n2 THEN g.nombre_2 END,
    g.apellido_1,
    g.apellido_2,
    g.fecha_nac,
    g.sexo,
    'usuario' || g.n || '@pascualbravo.edu.co',
    left(md5(random()::text), 20),
    (3000000000 + floor(random() * 300000000))::bigint,
    now() - random() * interval '1095 days'
FROM (
    SELECT t.n, t.tipo,
           (ARRAY['Juan','Carlos','Andrés','Luis','Miguel','Santiago','Daniel','David','Felipe','Sebastián',
                  'María','Laura','Ana','Camila','Valentina','Sofía','Daniela','Paula','Carolina','Natalia']
           )[1 + floor(random() * 20)::int] AS nombre_1,
           (ARRAY['Juan','Carlos','Andrés','Luis','Miguel','Santiago','Daniel','David','Felipe','Sebastián',
                  'María','Laura','Ana','Camila','Valentina','Sofía','Daniela','Paula','Carolina','Natalia']
           )[1 + floor(random() * 20)::int] AS nombre_2,
           random() < 0.5 AS tiene_n2,
           (ARRAY['García','Rodríguez','Martínez','López','González','Pérez','Sánchez','Ramírez','Torres','Flores',
                  'Rivera','Gómez','Díaz','Hernández','Vargas','Castro','Moreno','Jiménez','Ortiz','Ruiz']
           )[1 + floor(random() * 20)::int] AS apellido_1,
           (ARRAY['García','Rodríguez','Martínez','López','González','Pérez','Sánchez','Ramírez','Torres','Flores',
                  'Rivera','Gómez','Díaz','Hernández','Vargas','Castro','Moreno','Jiménez','Ortiz','Ruiz']
           )[1 + floor(random() * 20)::int] AS apellido_2,
           CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END AS sexo,

           CURRENT_DATE - (r.emin * 365 + floor(random() * ((r.emax - r.emin) * 365))::int) AS fecha_nac
    FROM tmp_tipo t
    JOIN (VALUES (1,18,30),(2,28,65),(3,23,60),(4,22,62),(5,25,65),
                 (6,25,65),(7,18,35),(8,40,75),(9,18,70)) AS r(tipo, emin, emax)
      ON r.tipo = t.tipo
    ORDER BY t.n
    OFFSET 0
) g;

INSERT INTO usuario_tipo_usuario (id_usuario, id_tipo_usuario)
SELECT u.id_usuario, t.tipo
FROM usuario u
JOIN tmp_tipo t ON t.n = substring(u.correo from 'usuario([0-9]+)@')::int;

INSERT INTO evento (id_tipo_evento, id_usuario, nombre, contenido,
                    fecha_evento, fecha_inicio, fecha_fin, lugar)
SELECT g.tipo,
       g.usr,
       g.prefijo || ' #' || g.n,
       'Evento de prueba número ' || g.n || ' generado automáticamente.',
       g.f_evento,
       g.f_evento + g.dias * interval '1 day',
       g.f_evento + g.dias * interval '1 day' + g.horas * interval '1 hour',
       g.lugar
FROM (
    SELECT n,
           1 + floor(random() * 20)::int      AS tipo,
           1 + floor(random() * 18550)::int   AS usr,
           (ARRAY['Congreso','Conferencia','Taller','Seminario','Foro',
                  'Feria','Concurso','Torneo','Charla','Encuentro'])[1 + floor(random() * 10)::int] AS prefijo,
           (ARRAY['Auditorio Principal','Biblioteca','Cancha Deportiva','Aula Magna',
                  'Sala de Conferencias','Plazoleta Central','Laboratorio de Cómputo','Cafetería'])[1 + floor(random() * 8)::int] AS lugar,
           now() - random() * interval '365 days' AS f_evento,
           1 + floor(random() * 60)::int AS dias,
           1 + floor(random() * 8)::int AS horas
    FROM generate_series(1, 3000) AS n
    OFFSET 0
) g;

INSERT INTO servicio (id_tipo_servicio, id_usuario, nombre, descripcion, fecha_servicio, estado)
SELECT 1 + floor(random() * 20)::int,
       g.usr,
       g.prefijo || ' ' || g.n,
       'Servicio de prueba número ' || g.n || ' generado automáticamente.',
       now() - random() * interval '365 days',
       (ARRAY['Disponible', 'No disponible', 'Eliminado'])[1 + floor(random() * 3)::int] AS estado
FROM (
    SELECT n,
           1 + floor(random() * 18550)::int AS usr,
           (ARRAY['Asesoría','Clases','Mantenimiento','Diseño','Transporte',
                  'Reparación','Fotografía','Traducción','Catering','Limpieza'])[1 + floor(random() * 10)::int] AS prefijo
    FROM generate_series(1, 3000) AS n
    OFFSET 0
) g;

INSERT INTO producto (id_tipo_producto, id_usuario, nombre, descripcion,
                      cantidad, precio, fecha_producto, estado)
SELECT g.tipo, g.usr,
       g.prefijo || ' ' || g.n,
       'Producto de prueba número ' || g.n || ' generado automáticamente.',
       g.cantidad,
       g.precio,
       now() - random() * interval '365 days',
       (ARRAY['Disponible', 'No disponible', 'Eliminado'])[1 + floor(random() * 3)::int] AS estado
FROM (
    SELECT n,
           1 + floor(random() * 20)::int      AS tipo,
           1 + floor(random() * 18550)::int   AS usr,
           (ARRAY['Libro','Moto','Bicicleta','Portátil','Celular',
                  'Silla','Escritorio','Guitarra','Balón','Zapatos'])[1 + floor(random() * 10)::int] AS prefijo,
           (1 + floor(random() * 1000))::smallint AS cantidad,
           round((1000 + random() * 999000)::numeric, 2) AS precio
    FROM generate_series(1, 3000) AS n
    OFFSET 0
) g;

INSERT INTO evento_usuario (id_usuario, id_evento, fecha_ingreso)
SELECT g.usr, g.ev, e.fecha_evento + random() * interval '10 days'
FROM (
    SELECT 1 + floor(random() * 18550)::int AS usr,
           1 + floor(random() * 3000)::int  AS ev
    FROM generate_series(1, 6000)
    OFFSET 0
) g
JOIN evento e ON e.id_evento = g.ev
ON CONFLICT DO NOTHING;

INSERT INTO servicio_solicitud (id_usuario, id_servicio, lugar, fecha_realizacion_servicio, estado)
SELECT g.usr, g.srv, g.lugar, now() - random() * interval '300 days',
       (ARRAY['Pendiente', 'Completado', 'Cancelado'])[1 + floor(random() * 3)::int] AS estado
FROM (
    SELECT 1 + floor(random() * 18550)::int AS usr,
           1 + floor(random() * 3000)::int  AS srv,
           (ARRAY['Campus Principal','Biblioteca','Domicilio del cliente','Sala de Estudio',
                  'Cafetería','Laboratorio','Plazoleta Central','Oficina del prestador'])[1 + floor(random() * 8)::int] AS lugar
    FROM generate_series(1, 5000)
    OFFSET 0
) g;

INSERT INTO producto_transaccion (id_usuario, id_producto, cantidad_compra, precio_compra, fecha_compra)
SELECT g.usr, g.prod, g.cant, p.precio, now() - random() * interval '300 days'
FROM (
    SELECT 1 + floor(random() * 18550)::int AS usr,
           1 + floor(random() * 3000)::int  AS prod,
           (1 + floor(random() * 5))::smallint AS cant
    FROM generate_series(1, 5000)
    OFFSET 0
) g
JOIN producto p ON p.id_producto = g.prod;