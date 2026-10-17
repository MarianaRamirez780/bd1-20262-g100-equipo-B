--
-- Scripst de Creación de la Base de Datos - SGBD MS SQL Server
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con las tablas relacionadas. Primero las independientes y después las dependientes
--

--
-- Creación de las tablas
--

CREATE TABLE rol (
	id_rol SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_usuario (
	id_tipo_usuario SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_servicio (
	id_tipo_servicio SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_producto (
	id_tipo_producto SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE tipo_evento (
	id_tipo_evento SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(500)
);

CREATE TABLE usuario (
	id_usuario INT IDENTITY(1,1) PRIMARY KEY,
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
	fecha_registro DATETIME2 NOT NULL,
	FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON UPDATE CASCADE
);

CREATE TABLE usuario_tipo_usuario (
	id_usuario INT NOT NULL,
	id_tipo_usuario SMALLINT NOT NULL,
	PRIMARY KEY (id_usuario, id_tipo_usuario), -- Clave compuesta
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario) ON UPDATE CASCADE
);

CREATE TABLE perfil (
	id_perfil INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_grupo INT NOT NULL,
	biografia VARCHAR(500),
	foto VARBINARY(MAX) NOT NULL,
	perfil_extra NVARCHAR(MAX),
	fecha_perfil DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE grupo (
	id_grupo INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_perfil INT NOT NULL,
	descipcion VARCHAR(500),
	fecha_creacion DATETIME2 NOT NULL,
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil) ON UPDATE CASCADE
);

ALTER TABLE perfil	-- Ya que antes no existía la tabla grupo para poder referenciar
ADD CONSTRAINT fk_perfil_grupo
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE;

CREATE TABLE usuario_grupo (
	id_usuario INT NOT NULL,
	id_grupo INT NOT NULL,
	PRIMARY KEY (id_usuario, id_grupo),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON UPDATE CASCADE
);

CREATE TABLE publicacion (
	id_publicacion BIGINT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_perfil INT NOT NULL,
	titulo VARCHAR(50) NOT NULL,
	texto VARCHAR(5000),
	URL VARCHAR(1000),
	imagen VARBINARY(MAX),
	fecha_publicacion DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil) ON UPDATE CASCADE
);

CREATE TABLE comentario (
	id_comentario BIGINT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_publicacion BIGINT NOT NULL,
	texto VARCHAR(2000),
	fecha_comentario DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON UPDATE CASCADE
);

CREATE TABLE servicio (
	id_servicio INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(200),
	fecha_servicio DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE servicio_tipo_servicio (
	id_servicio INT NOT NULL,
	id_tipo_servicio SMALLINT NOT NULL,
	PRIMARY KEY (id_servicio, id_tipo_servicio),
	FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio) ON UPDATE CASCADE,
	FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio) ON UPDATE CASCADE
);

CREATE TABLE producto (
	id_producto INT IDENTITY(1,1) PRIMARY KEY,
	id_tipo_producto SMALLINT NOT NULL,
	id_usuario INT NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(300),
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 0 AND cantidad <= 1000),
	precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0 AND precio <= 20000000),
	fecha_producto DATETIME2 NOT NULL,
	FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE compra_producto (
	id_compra INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_producto INT NOT NULL,
	cantidad_compra SMALLINT CHECK (cantidad_compra >= 0 AND cantidad_compra <= 1000),
	precio_compra DECIMAL(10,2) NOT NULL CHECK (precio_compra >= 0 AND precio_compra <= 20000000),
	fecha_compra DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON UPDATE CASCADE
);

CREATE TABLE detalle_servicio (
	id_detalle_servicio INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_servicio INT NOT NULL,
	lugar VARCHAR(100) NOT NULL,
	fecha_realizacion_servicio DATETIME2 NOT NULL,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio) ON UPDATE CASCADE
);

CREATE TABLE intercambio_producto (
	id_intercambio INT IDENTITY(1,1) PRIMARY KEY,
	id_prod_ofrecido INT NOT NULL,
	id_prod_solicitado INT NOT NULL CHECK (id_prod_solicitado <> id_prod_ofrecido),
	fecha_intercambio DATETIME2 NOT NULL,
	cantidad SMALLINT NOT NULL CHECK (cantidad >= 0 AND cantidad <= 1000),
	fecha_respuesta DATETIME2,
	respuesta BIT,
	FOREIGN KEY (id_prod_ofrecido) REFERENCES producto(id_producto) ON UPDATE CASCADE,
	FOREIGN KEY (id_prod_solicitado) REFERENCES producto(id_producto) ON UPDATE CASCADE
);

CREATE TABLE evento (
	id_evento INT IDENTITY(1,1) PRIMARY KEY,
	id_tipo_evento SMALLINT NOT NULL,
	id_usuario INT NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	contenido VARCHAR(600),
	fecha_evento DATETIME2 NOT NULL,
	fecha_inicio DATETIME2 NOT NULL,
	fecha_fin DATETIME2 CHECK (fecha_fin >= fecha_inicio),
	lugar VARCHAR(30) NOT NULL,
	FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento(id_tipo_evento) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE usuario_evento (
	id_usuario INT NOT NULL,
	id_evento INT NOT NULL,
	fecha_ingreso DATETIME2 NOT NULL,
	PRIMARY KEY (id_usuario, id_evento),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON UPDATE CASCADE
);

CREATE TABLE chat_privado (
	id_chat INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario_1 INT NOT NULL,
	id_usuario_2 INT NOT NULL CHECK (id_usuario_2 <> id_usuario_1),
	FOREIGN KEY (id_usuario_1) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario_2) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE mensaje_privado (
	id_mensaje BIGINT IDENTITY(1,1) PRIMARY KEY,
	id_chat INT NOT NULL,
	id_usuario INT NOT NULL,
	texto VARCHAR(2000),
	URL VARCHAR(2000),
	imagen VARBINARY(MAX),
	audio VARBINARY(MAX),
	fecha_mensaje DATETIME2 NOT NULL,
	FOREIGN KEY (id_chat) REFERENCES chat_privado(id_chat) ON UPDATE CASCADE,
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE
);

CREATE TABLE tipo_notificacion (
	id_tipo_notificacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	id_publicacion BIGINT,
	id_comentario BIGINT,
	id_compra INT,
	id_detalle_servicio INT,
	id_intercambio INT,
	id_evento INT,
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
	id_notificacion BIGINT IDENTITY(1,1) PRIMARY KEY,
	id_tipo_notificacion SMALLINT NOT NULL,
	mensaje VARCHAR(50),
	fecha_notificacion DATETIME2 NOT NULL,
	FOREIGN KEY (id_tipo_notificacion) REFERENCES tipo_notificacion(id_tipo_notificacion) ON UPDATE CASCADE
);

CREATE TABLE notificacion_usuario (
	id_usuario INT NOT NULL,
	id_notificacion BIGINT NOT NULL,
	PRIMARY KEY (id_usuario, id_notificacion),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	FOREIGN KEY (id_notificacion) REFERENCES notificacion(id_notificacion) ON UPDATE CASCADE
);