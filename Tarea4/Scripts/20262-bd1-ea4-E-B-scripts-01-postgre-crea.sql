--
-- Scripst de Creación de la Base de Datos  - SGBD PostgreSQL
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con las tablas relacionadas. Primero las independientes y después las dependientes
--

--
-- Creación de las tablas
--

CREATE TABLE rol (
	id_rol SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_usuario (
	id_tipo_usuario SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_servicio (
	id_tipo_servicio SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_producto (
	id_tipo_producto SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_evento (
	id_tipo_evento SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(500)
);

CREATE TABLE usuario (
	id_usuario SERIAL PRIMARY KEY,
	id_rol SMALLINT NOT NULL,
	nombre_1 VARCHAR(30) NOT NULL,
	nombre_2 VARCHAR(30),
	apellido_1 VARCHAR(30) NOT NULL,
	apellido_2 VARCHAR(30) NOT NULL,
	fecha_nac DATE NOT NULL,
	edad SMALLINT NOT NULL CHECK (edad >= 0 AND edad <= 150),
	sexo CHAR(1) CHECK (sexo = 'M' OR sexo = 'F' OR sexo IS NULL),
	correo VARCHAR(50) UNIQUE NOT NULL,
	contrasena VARCHAR(25) NOT NULL,
	telefono BIGINT CHECK (telefono >= 100000 AND telefono <= 999999999999999),
	fecha_registro TIMESTAMP NOT NULL,
	FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON UPDATE CASCADE
);

CREATE TABLE usuario_tipo_usuario (
	id_usuario INTEGER NOT NULL,
	id_tipo_usuario SMALLINT NOT NULL,
	PRIMARY KEY (id_usuario, id_tipo_usuario), -- Clave compuesta
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario) ON UPDATE CASCADE
);

CREATE TABLE perfil (
	id_perfil SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_grupo INTEGER NOT NULL,
	biografia VARCHAR(500),
	foto BYTEA NOT NULL,
	perfil_extra JSONB,
	fecha_perfil TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE grupo (
	id_grupo SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_perfil INTEGER NOT NULL,
	descipcion VARCHAR(500),
	fecha_creacion TIMESTAMP NOT NULL,
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil) ON UPDATE CASCADE
);

ALTER TABLE perfil	-- Ya que antes no existía la tabla grupo para poder referenciar
ADD CONSTRAINT fk_perfil_grupo
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE;

CREATE TABLE usuario_grupo (
	id_usuario INTEGER NOT NULL,
	id_grupo INTEGER NOT NULL,
	PRIMARY KEY (id_usuario, id_grupo),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE
);

CREATE TABLE publicacion (
	id_publicacion BIGSERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_perfil INTEGER NOT NULL,
	titulo VARCHAR(50) NOT NULL,
	texto VARCHAR(5000),
	URL VARCHAR(1000),
	imagen BYTEA,
	fecha_publicacion TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil) ON UPDATE CASCADE
);

CREATE TABLE comentario (
	id_comentario BIGSERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_publicacion BIGINT NOT NULL,
	texto VARCHAR(2000),
	fecha_comentario TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE
);

CREATE TABLE servicio (
	id_servicio SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(200),
	fecha_servicio TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE servicio_tipo_servicio (
	id_servicio INTEGER NOT NULL,
	id_tipo_servicio SMALLINT NOT NULL,
	PRIMARY KEY (id_servicio, id_tipo_servicio),
	FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio) ON UPDATE CASCADE,
	FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio) ON UPDATE CASCADE
);

CREATE TABLE producto (
	id_producto SERIAL PRIMARY KEY,
	id_tipo_producto SMALLINT NOT NULL,
	id_usuario INTEGER NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(300),
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 0 AND cantidad <= 1000),
	precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0 AND precio <= 20000000),
	fecha_producto TIMESTAMP NOT NULL,
	FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE compra_producto (
	id_compra SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_producto INTEGER NOT NULL,
	cantidad_compra SMALLINT CHECK (cantidad_compra >= 0 AND cantidad_compra <= 1000),
	precio_compra DECIMAL(10,2) NOT NULL CHECK (precio_compra >= 0 AND precio_compra <= 20000000),
	fecha_compra TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON UPDATE CASCADE
);

CREATE TABLE detalle_servicio (
	id_detalle_servicio SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_servicio INTEGER NOT NULL,
	lugar VARCHAR(100) NOT NULL,
	fecha_realizacion_servicio TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio) ON UPDATE CASCADE
);

CREATE TABLE intercambio_producto (
	id_intercambio SERIAL PRIMARY KEY,
	id_prod_ofrecido INTEGER NOT NULL,
	id_prod_solicitado INTEGER NOT NULL CHECK (id_prod_solicitado <> id_prod_ofrecido),
	fecha_intercambio TIMESTAMP NOT NULL,
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 0 AND cantidad <= 1000),
	fecha_respuesta TIMESTAMP,
	respuesta BOOLEAN,
	FOREIGN KEY (id_prod_ofrecido) REFERENCES producto(id_producto) ON UPDATE CASCADE,
	FOREIGN KEY (id_prod_solicitado) REFERENCES producto(id_producto) ON UPDATE CASCADE
);

CREATE TABLE evento (
	id_evento SERIAL PRIMARY KEY,
	id_tipo_evento SMALLINT NOT NULL,
	id_usuario INTEGER NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	contenido VARCHAR(600),
	fecha_evento TIMESTAMP NOT NULL,
	fecha_inicio TIMESTAMP NOT NULL,
	fecha_fin TIMESTAMP CHECK (fecha_fin >= fecha_inicio),
	lugar VARCHAR(30) NOT NULL,
	FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento(id_tipo_evento) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE usuario_evento (
	id_usuario INTEGER NOT NULL,
	id_evento INTEGER NOT NULL,
	fecha_ingreso TIMESTAMP NOT NULL,
	PRIMARY KEY (id_usuario, id_evento),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON UPDATE CASCADE
);

CREATE TABLE chat_privado (
	id_chat SERIAL PRIMARY KEY,
	id_usuario_1 INTEGER NOT NULL,
	id_usuario_2 INTEGER NOT NULL CHECK (id_usuario_2 <> id_usuario_1),
	FOREIGN KEY (id_usuario_1) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario_2) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE mensaje_privado (
	id_mensaje BIGSERIAL PRIMARY KEY,
	id_chat INTEGER NOT NULL,
	id_usuario INTEGER NOT NULL,
	texto VARCHAR(2000),
	URL VARCHAR(2000),
	imagen BYTEA,
	audio BYTEA,
	fecha_mensaje TIMESTAMP NOT NULL,
	FOREIGN KEY (id_chat) REFERENCES chat_privado(id_chat) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE tipo_notificacion (
	id_tipo_notificacion SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_publicacion BIGINT,
	id_comentario BIGINT,
	id_compra INTEGER,
	id_detalle_servicio INTEGER,
	id_intercambio INTEGER,
	id_evento INTEGER,
	id_mensaje BIGINT,
	FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE,
	FOREIGN KEY (id_comentario) REFERENCES comentario(id_comentario) ON UPDATE CASCADE,
	FOREIGN KEY (id_detalle_servicio) REFERENCES detalle_servicio(id_detalle_servicio) ON UPDATE CASCADE,
	FOREIGN KEY (id_compra) REFERENCES compra_producto(id_compra) ON UPDATE CASCADE,
	FOREIGN KEY (id_intercambio) REFERENCES intercambio_producto(id_intercambio) ON UPDATE CASCADE,
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON UPDATE CASCADE,
	FOREIGN KEY (id_mensaje) REFERENCES mensaje_privado(id_mensaje) ON UPDATE CASCADE
);

CREATE TABLE notificacion (
	id_notificacion BIGSERIAL PRIMARY KEY,
	id_tipo_notificacion SMALLINT NOT NULL,
	mensaje VARCHAR(50),
	fecha_notificacion TIMESTAMP NOT NULL,
	FOREIGN KEY (id_tipo_notificacion) REFERENCES tipo_notificacion(id_tipo_notificacion) ON UPDATE CASCADE
);

CREATE TABLE notificacion_usuario (
	id_usuario INTEGER NOT NULL,
	id_notificacion BIGINT NOT NULL,
	PRIMARY KEY (id_usuario, id_notificacion),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_notificacion) REFERENCES notificacion(id_notificacion) ON UPDATE CASCADE
);