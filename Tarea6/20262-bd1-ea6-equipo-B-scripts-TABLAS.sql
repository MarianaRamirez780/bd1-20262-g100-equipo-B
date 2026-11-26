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
	nombre VARCHAR(50) UNIQUE NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_usuario (
	id_tipo_usuario SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_servicio (
	id_tipo_servicio SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_producto (
	id_tipo_producto SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_evento (
	id_tipo_evento SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	descripcion VARCHAR(500)
);

CREATE TABLE usuario (
	id_usuario SERIAL PRIMARY KEY,
	id_rol SMALLINT NOT NULL,
	nombre_1 VARCHAR(30) NOT NULL,
	nombre_2 VARCHAR(30),
	apellido_1 VARCHAR(30) NOT NULL,
	apellido_2 VARCHAR(30) NOT NULL,
	fecha_nac DATE NOT NULL CHECK (fecha_nac <= CURRENT_DATE),
	sexo CHAR(1) NOT NULL CHECK (sexo = 'M' OR sexo = 'F'),
	correo VARCHAR(50) UNIQUE NOT NULL,
	contrasena VARCHAR(25) NOT NULL,
	telefono BIGINT CHECK (telefono >= 1000000 AND telefono <= 999999999999999),
	fecha_registro TIMESTAMP NOT NULL,
	FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

CREATE TABLE usuario_tipo_usuario (
	id_usuario INTEGER NOT NULL,
	id_tipo_usuario SMALLINT NOT NULL,
	PRIMARY KEY (id_usuario, id_tipo_usuario),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario)
);

CREATE TABLE perfil (
	id_perfil SERIAL PRIMARY KEY,
	id_usuario INTEGER,
	id_grupo INTEGER,
	biografia VARCHAR(500),
	foto BYTEA NOT NULL,
	perfil_extra JSONB,
	fecha_perfil TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE grupo (
	id_grupo SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_perfil INTEGER NOT NULL,
	descripcion VARCHAR(500),
	fecha_creacion TIMESTAMP NOT NULL,
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);

ALTER TABLE perfil
ADD CONSTRAINT fk_perfil_grupo
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo);

CREATE TABLE grupo_usuario (
	id_usuario INTEGER NOT NULL,
	id_grupo INTEGER NOT NULL,
	PRIMARY KEY (id_usuario, id_grupo),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
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
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);

CREATE TABLE comentario (
	id_comentario BIGSERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_publicacion BIGINT NOT NULL,
	texto VARCHAR(2000),
	fecha_comentario TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion)
);

CREATE TABLE servicio (
	id_servicio SERIAL PRIMARY KEY,
	id_tipo_servicio INTEGER NOT NULL,
	id_usuario INTEGER NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(200),
	fecha_servicio TIMESTAMP NOT NULL,
	estado VARCHAR(15) NOT NULL DEFAULT 'Disponible' CHECK (estado IN ('Disponible', 'No disponible', 'Eliminado')),
	FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE producto (
	id_producto SERIAL PRIMARY KEY,
	id_tipo_producto SMALLINT NOT NULL,
	id_usuario INTEGER NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(300),
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 1 AND cantidad <= 1000),
	precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0 AND precio <= 20000000),
	fecha_producto TIMESTAMP NOT NULL,
	estado VARCHAR(15) NOT NULL DEFAULT 'Disponible' CHECK (estado IN ('Disponible', 'No disponible', 'Eliminado')),
	FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE producto_transaccion (
	id_transaccion SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_producto INTEGER NOT NULL,
	cantidad_compra SMALLINT NOT NULL CHECK (cantidad_compra >= 1 AND cantidad_compra <= 1000),
	precio_compra DECIMAL(10,2) NOT NULL CHECK (precio_compra >= 0 AND precio_compra <= 20000000),
	fecha_compra TIMESTAMP NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE servicio_solicitud (
	id_solicitud SERIAL PRIMARY KEY,
	id_usuario INTEGER NOT NULL,
	id_servicio INTEGER NOT NULL,
	lugar VARCHAR(100) NOT NULL,
	fecha_realizacion_servicio TIMESTAMP NOT NULL,
	estado VARCHAR(15) NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Completado', 'Cancelado')),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

CREATE TABLE intercambio_producto (
	id_intercambio SERIAL PRIMARY KEY,
	id_usuario_intercambio INTEGER NOT NULL,
	id_prod_ofrecido INTEGER NOT NULL,
	id_prod_solicitado INTEGER NOT NULL CHECK (id_prod_solicitado <> id_prod_ofrecido),
	fecha_intercambio TIMESTAMP NOT NULL,
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 0 AND cantidad <= 1000),
	fecha_respuesta TIMESTAMP,
	respuesta BOOLEAN DEFAULT NULL, -- null = sin respuesta, 0 = rechazado, 1 = aceptado
	FOREIGN KEY (id_usuario_intercambio) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_prod_ofrecido) REFERENCES producto(id_producto),
	FOREIGN KEY (id_prod_solicitado) REFERENCES producto(id_producto)
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
	FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento(id_tipo_evento),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE evento_usuario (
	id_usuario INTEGER NOT NULL,
	id_evento INTEGER NOT NULL,
	fecha_ingreso TIMESTAMP NOT NULL,
	PRIMARY KEY (id_usuario, id_evento),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
);

CREATE TABLE chat_privado (
	id_chat SERIAL PRIMARY KEY,
	id_usuario_1 INTEGER NOT NULL,
	id_usuario_2 INTEGER NOT NULL CHECK (id_usuario_2 <> id_usuario_1),
	FOREIGN KEY (id_usuario_1) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_usuario_2) REFERENCES usuario(id_usuario)
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
	FOREIGN KEY (id_chat) REFERENCES chat_privado(id_chat),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE tipo_notificacion (
	id_tipo_notificacion SMALLSERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_publicacion BIGINT,
	id_comentario BIGINT,
	id_transaccion INTEGER,
	id_solicitud INTEGER,
	id_intercambio INTEGER,
	id_evento INTEGER,
	id_mensaje BIGINT,
	FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
	FOREIGN KEY (id_comentario) REFERENCES comentario(id_comentario),
	FOREIGN KEY (id_solicitud) REFERENCES servicio_solicitud(id_solicitud),
	FOREIGN KEY (id_transaccion) REFERENCES producto_transaccion(id_transaccion),
	FOREIGN KEY (id_intercambio) REFERENCES intercambio_producto(id_intercambio),
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
	FOREIGN KEY (id_mensaje) REFERENCES mensaje_privado(id_mensaje)
);

CREATE TABLE notificacion (
	id_notificacion BIGSERIAL PRIMARY KEY,
	id_tipo_notificacion SMALLINT NOT NULL,
	mensaje VARCHAR(50),
	fecha_notificacion TIMESTAMP NOT NULL,
	FOREIGN KEY (id_tipo_notificacion) REFERENCES tipo_notificacion(id_tipo_notificacion)
);

CREATE TABLE notificacion_usuario (
	id_usuario INTEGER NOT NULL,
	id_notificacion BIGINT NOT NULL,
	PRIMARY KEY (id_usuario, id_notificacion),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (id_notificacion) REFERENCES notificacion(id_notificacion)
);
