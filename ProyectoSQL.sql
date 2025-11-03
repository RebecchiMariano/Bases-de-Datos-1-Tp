create database AppColectivos;
use AppColectivos;

--Tabla de Lineas:--

--Creación de la tabla Lineas--
IF OBJECT_ID('dbo.Lineas','U') IS NOT NULL DROP TABLE dbo.Lineas;
GO
CREATE TABLE dbo.Lineas (
    NumeroDeLinea INT PRIMARY KEY,
    Nombre        VARCHAR(80) NOT NULL
);

--Carga de datos iniciales--
INSERT INTO dbo.Lineas (NumeroDeLinea, Nombre) VALUES
(7 , 'Línea 7'),
(22, 'Línea 22'),
(39, 'Línea 39'),
(45, 'Línea 45'),
(60, 'Línea 60');
GO

--Tabla de Seguros--

IF OBJECT_ID('dbo.Seguros','U') IS NOT NULL DROP TABLE dbo.Seguros;
GO

--Creación de la tabla Seguros--
CREATE TABLE dbo.Seguros (
    IdSeguro INT PRIMARY KEY NOT NULL,
    Empresa NVARCHAR(100) NOT NULL,
    DiaDeContratacion DATE NOT NULL,
    DiaFinDeContrato DATE NOT NULL,
    CostoSeguro INT NOT NULL
);

--Carga de datos iniciales--
INSERT INTO dbo.Seguros (IdSeguro, Empresa, DiaDeContratacion, DiaFinDeContrato, CostoSeguro) VALUES
(1, 'La Caja', '2024-01-10', '2025-01-10', 120000),
(2, 'Sancor Seguros', '2023-06-01', '2024-06-01', 95000),
(3, 'Mapfre', '2024-03-15', '2025-03-15', 110000),
(4, 'Allianz', '2024-09-01', '2025-09-01', 105000),
(5, 'Federación Patronal', '2023-12-20', '2024-12-20', 99000),
(6, 'Zurich', '2024-05-05', '2025-05-05', 115000);
GO

--Tabla de Localidades--

IF OBJECT_ID('dbo.Localidad','U') IS NOT NULL DROP TABLE dbo.Localidad;
GO

--Creación de la tabla Localidad--
CREATE TABLE dbo.Localidad (
    IdLocalidad INT IDENTITY(1,1) PRIMARY KEY,
    ComunaCapital TINYINT NULL,
    PartidoZonaSur TINYINT NULL,   -- 1=Lanús, 2=Avellaneda, 3=Quilmes
    Nombre VARCHAR(80) NOT NULL,
    CONSTRAINT CK_Localidad_OnlyOne CHECK (
        (ComunaCapital BETWEEN 1 AND 11 AND PartidoZonaSur IS NULL)
     OR (ComunaCapital IS NULL AND PartidoZonaSur IN (1,2,3))
    )
);

--Carga de datos iniciales--
-- 11 comunas --
INSERT INTO dbo.Localidad (ComunaCapital, PartidoZonaSur, Nombre) VALUES
(1 , NULL, 'Comuna 1'),
(2 , NULL, 'Comuna 2'),
(3 , NULL, 'Comuna 3'),
(4 , NULL, 'Comuna 4'),
(5 , NULL, 'Comuna 5'),
(6 , NULL, 'Comuna 6'),
(7 , NULL, 'Comuna 7'),
(8 , NULL, 'Comuna 8'),
(9 , NULL, 'Comuna 9'),
(10, NULL, 'Comuna 10'),
(11, NULL, 'Comuna 11');

-- Zona Sur --
INSERT INTO dbo.Localidad (ComunaCapital, PartidoZonaSur, Nombre) VALUES
(NULL, 1, 'Lanús'),
(NULL, 2, 'Avellaneda'),
(NULL, 3, 'Quilmes');
GO


--Tabla de Paradas--

IF OBJECT_ID('dbo.Paradas','U') IS NOT NULL DROP TABLE dbo.Paradas;
GO

--Creación de la tabla Paradas--
CREATE TABLE dbo.Paradas (
    IdParada INT IDENTITY(1,1) PRIMARY KEY,
    NombreParada VARCHAR(80) NOT NULL,
    DireccionParada VARCHAR(120) NOT NULL,
    IdLocalidad INT NOT NULL FOREIGN KEY REFERENCES dbo.Localidad(IdLocalidad)
);

--Carga de datos iniciales--
INSERT INTO dbo.Paradas (NombreParada, DireccionParada, IdLocalidad) VALUES
('Retiro',        'Av. Ramos Mejía 1358', 1),
('Once',          'Av. Pueyrredón 400',   3),
('Lanús',         'Av. Hipólito Yrigoyen 4500', 12),
('Avellaneda',    'Av. Mitre 800',        13),
('Quilmes',       'Av. Hipólito Yrigoyen 200', 14),
('Constitución',  'Lima 1400',            1),
('Palermo',       'Av. Santa Fe 4200',    2),
('Belgrano',      'Av. Cabildo 2200',     5),
('Caballito',     'Av. Rivadavia 4800',   6),
('Liniers',       'Av. Rivadavia 11200',  9);
GO

--Tabla de Colectivos--

IF OBJECT_ID('dbo.Colectivos','U') IS NOT NULL DROP TABLE dbo.Colectivos;
GO

--Creación de la tabla Colectivos--
CREATE TABLE dbo.Colectivos (
    IdColectivo INT IDENTITY(1,1) PRIMARY KEY,
    Anio INT NOT NULL,
    Modelo VARCHAR(60) NOT NULL,
    Patente VARCHAR(10) NOT NULL,
    Vtv DATE NOT NULL,
    Capacidad INT NOT NULL,
    AireAcondicionado BIT NOT NULL,
    IdSeguro INT NULL,
    NumeroDeLinea INT NOT NULL,
    CONSTRAINT CK_Colectivos_Anio CHECK (Anio BETWEEN 2000 AND YEAR(GETDATE())),
    CONSTRAINT CK_Colectivos_Capacidad CHECK (Capacidad BETWEEN 20 AND 70),
    CONSTRAINT CK_Colectivos_PatenteFormato CHECK (
        UPPER(Patente) LIKE '[A-Z][A-Z][0-9][0-9][0-9][A-Z][A-Z]'
        OR UPPER(Patente) LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'
    ),
    CONSTRAINT FK_Colectivos_Lineas FOREIGN KEY (NumeroDeLinea) REFERENCES dbo.Lineas(NumeroDeLinea),
    CONSTRAINT FK_Colectivos_Seguros FOREIGN KEY (IdSeguro) REFERENCES dbo.Seguros(IdSeguro)
);
CREATE UNIQUE INDEX UX_Colectivos_Patente ON dbo.Colectivos(Patente);

--Carga de datos iniciales--
INSERT INTO dbo.Colectivos (Anio, Modelo, Patente, Vtv, Capacidad, AireAcondicionado, IdSeguro, NumeroDeLinea) VALUES
(2018, 'Mercedes-Benz OF1721', 'AB123CD', '2025-08-20', 45, 1, 2, 7),
(2015, 'Agrale MT12',         'AC456EF', '2025-06-15', 38, 1, NULL, 22),
(2020, 'Scania K250',         'AD789GH', '2025-11-10', 52, 1, 4, 39),
(2012, 'Iveco 170E',          'AE321IJ', '2025-05-05', 40, 0, 2, 45),
(2017, 'Mercedes-Benz OH1621','AF654KL', '2025-09-13', 42, 1, NULL, 60),
(2019, 'Volkswagen 17.230',   'AG987MN', '2025-07-30', 44, 1, 4, 7),
(2014, 'Agrale MT17',         'AH159OP', '2025-04-22', 36, 0, 1, 22),
(2021, 'Scania F280',         'AI753QR', '2025-10-18', 55, 1, NULL, 39),
(2016, 'Iveco 170E',          'AJ246ST', '2025-03-28', 40, 0, 4, 45),
(2022, 'Mercedes-Benz OF1726','AK802UV', '2025-12-05', 58, 1, 2, 60);
GO

--Tabla de Rutas y RutaParada--
IF OBJECT_ID('dbo.Rutas','U') IS NOT NULL DROP TABLE dbo.Rutas;
GO

--Creación de la tabla Rutas--
CREATE TABLE dbo.Rutas (
    IdRuta INT IDENTITY(1,1) PRIMARY KEY,
    NombreRuta VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL
);

IF OBJECT_ID('dbo.RutaParada','U') IS NOT NULL DROP TABLE dbo.RutaParada;
GO

--Creación de la tabla RutaParada--
CREATE TABLE dbo.RutaParada (
    IdRuta INT NOT NULL,
    IdParada INT NOT NULL,
    OrdenParada INT NOT NULL,
    PRIMARY KEY (IdRuta, IdParada),
    FOREIGN KEY (IdRuta) REFERENCES dbo.Rutas(IdRuta),
    FOREIGN KEY (IdParada) REFERENCES dbo.Paradas(IdParada)
);

--Carga de datos iniciales--
INSERT INTO dbo.Rutas (NombreRuta, Descripcion) VALUES
('Ruta 1', 'Retiro - Constitución - Lanús'),
('Ruta 2', 'Once - Caballito - Liniers - Quilmes'),
('Ruta 3', 'Palermo - Belgrano - Retiro - Avellaneda'),
('Ruta 4', 'Lanús - Avellaneda - Constitución'),
('Ruta 5', 'Quilmes - Lanús - Caballito - Palermo - Retiro');

INSERT INTO dbo.RutaParada (IdRuta, IdParada, OrdenParada) VALUES
(1,1,1),(1,6,2),(1,3,3),
(2,2,1),(2,9,2),(2,10,3),(2,5,4),
(3,7,1),(3,8,2),(3,1,3),(3,4,4),
(4,3,1),(4,4,2),(4,6,3),
(5,5,1),(5,3,2),(5,9,3),(5,7,4),(5,1,5);
GO

--Creacion de la tabla Sube (api externa)--

IF OBJECT_ID('dbo.Sube','U') IS NOT NULL DROP TABLE dbo.Sube;
GO
CREATE TABLE dbo.Sube (
    IdTicket INT IDENTITY(1,1) PRIMARY KEY,
    FechaDeTicket DATE NOT NULL,
    IdColectivo INT NOT NULL FOREIGN KEY REFERENCES dbo.Colectivos(IdColectivo)
);

-- Todos los viajes simulados para el día 2025-09-13
INSERT INTO dbo.Sube (FechaDeTicket, IdColectivo)
SELECT '2025-09-13', IdColectivo
FROM dbo.Colectivos
CROSS APPLY (SELECT TOP (CASE IdColectivo
    WHEN 1 THEN 10 WHEN 2 THEN 8 WHEN 3 THEN 13 WHEN 4 THEN 9
    WHEN 5 THEN 11 WHEN 6 THEN 7 WHEN 7 THEN 14 WHEN 8 THEN 6
    WHEN 9 THEN 10 ELSE 9 END) 1 AS n) AS t;
GO