--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de Tablas
-- 

--
-- 1.1.- Agregar un campo a la tabla de usuarios de la red social
--

ALTER TABLE usuario
ADD COLUMN direccion VARCHAR(100);

--
-- 1.2.- Modificar un campo de la tabla de usuarios
--

ALTER TABLE usuario
ALTER COLUMN contrasena TYPE VARCHAR(100);

--
-- Gestionar una tabla "nueva"
-- 1.- "agregar" una nueva tabla a la base de datos que tenga relación con el sistema
-- 2.- Darle un nombre "coherente"
-- 3.- Agregar campos coherentes con la tabla
-- 4.- Realizar todas las operaciones que se solicitan a continuación
--

-- 1.3.1
-- Crear una tabla "nueva" de su iniciativa (una tabla coherente con el sistema con su nombre, no coloque "nueva" como nombre)
--

CREATE TABLE reserva_aula (
    id_reserva SERIAL
);

-- 1.3.2
-- Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
-- Mínimo un campo tipo texto y uno numérico
--

ALTER TABLE reserva_aula
ADD PRIMARY KEY (id_reserva),
ADD COLUMN codigo_aula VARCHAR(30) NOT NULL,
ADD COLUMN capacidad_solicitada INT NOT NULL,
ADD COLUMN observaciones VARCHAR(200);

-- 1.3.3
-- Quitar uno de los campos de la tabla "nueva"
--

ALTER TABLE reserva_aula
DROP COLUMN observaciones;

-- 1.3.4
-- Cambiar el nombre de la tabla "nueva" a otro nombre "otro_nombre"
-- Todas las operaciones siguientes se realizan sobre la tabla renombrada
--

ALTER TABLE reserva_aula
RENAME TO reserva_espacio;

-- 1.3.5 
-- Agregar un campo único a la tabla 
--

ALTER TABLE reserva_espacio
ADD COLUMN codigo_confirmacion VARCHAR(30),
ADD CONSTRAINT uk_reserva_codigo UNIQUE (codigo_confirmacion);

-- 1.3.6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--

ALTER TABLE reserva_espacio
ADD COLUMN fecha_inicio TIMESTAMP NOT NULL,
ADD COLUMN fecha_fin TIMESTAMP NOT NULL,
ADD CONSTRAINT chk_reserva_espacio_fecha CHECK (fecha_fin >= fecha_inicio);

-- 1.3.7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--

ALTER TABLE reserva_espacio
ADD COLUMN horas_reservadas INT NOT NULL,
ADD CONSTRAINT chk_reserva_espacio_horas CHECK (horas_reservadas >= 0);

-- 1.3.8
-- Modificar el tamaño de un campo texto de la tabla renombra
--

ALTER TABLE reserva_espacio
ALTER COLUMN codigo_aula TYPE VARCHAR(20);

-- 1.3.7
-- Modificar el campo numeríco y colocar un control de rango 
--

ALTER TABLE reserva_espacio
ADD CONSTRAINT chk_reserva_capacidad_rango CHECK (capacidad_solicitada >= 1 AND capacidad_solicitada <= 2000);

-- 1.3.8
-- Agregar un índice a la tabla (cualquier campo)
--

CREATE INDEX idx_reserva_codigo_aula ON reserva_espacio (codigo_aula);

--
-- 1.3.9 
-- Eliminar una de las fechas
--

ALTER TABLE reserva_espacio
DROP COLUMN fecha_fin;

-- 1.3.10
-- Borrar todos los datos de una tabla sin dejar traza
--

TRUNCATE TABLE reserva_espacio;