-- ============================================
-- CREACIÓN Y USO DE BASE DE DATOS
-- ============================================
CREATE DATABASE ColectivosDB;
GO

USE ColectivosDB;
GO

-- ============================================
-- CREACIÓN DE TABLAS
-- ============================================

-- Tabla Localidad
CREATE TABLE Localidad (
    idLocalidad INT PRIMARY KEY,
    nombreLocalidad VARCHAR(50),
    tipoZona VARCHAR(20) CHECK (tipoZona IN ('Capital', 'Zona Sur'))
);

-- Tabla Lineas
CREATE TABLE Lineas (
    numeroDeLinea INT PRIMARY KEY,
    nombreLinea VARCHAR(50)
);

-- Tabla Seguros
CREATE TABLE Seguros (
    idSeguro INT PRIMARY KEY,
    Empresa VARCHAR(50),
    DiaDeContratacion DATE,
    DiaFinDeContrato DATE,
    CostoSeguro INT
);

-- Tabla Paradas
CREATE TABLE Paradas (
    idParada INT PRIMARY KEY,
    nombreParada VARCHAR(50),
    direccionParada VARCHAR(50),
    ParadaLocalidad INT,
    FOREIGN KEY (ParadaLocalidad) REFERENCES Localidad(idLocalidad)
);

-- Tabla Rutas
CREATE TABLE Rutas (
    idRutas INT PRIMARY KEY,
    nombreRuta VARCHAR(50),
    idLinea INT,
    FOREIGN KEY (idLinea) REFERENCES Lineas(numeroDeLinea)
);

-- Tabla RutaParada (Tabla asociativa)
CREATE TABLE RutaParada (
    idRuta INT,
    idParada INT,
    orden INT,
    PRIMARY KEY (idRuta, idParada),
    FOREIGN KEY (idRuta) REFERENCES Rutas(idRutas),
    FOREIGN KEY (idParada) REFERENCES Paradas(idParada)
);

-- Tabla Colectivos
CREATE TABLE Colectivos (
    idColectivo INT PRIMARY KEY,
    Anio INT,
    Modelo VARCHAR(50),
    Patente VARCHAR(9),
    Vtv DATE,
    Capacidad INT,
    AireAcondicionado BIT,
    SeguroDelColectivo INT,
    LineaDelColectivo INT,
    FOREIGN KEY (SeguroDelColectivo) REFERENCES Seguros(idSeguro),
    FOREIGN KEY (LineaDelColectivo) REFERENCES Lineas(numeroDeLinea)
);

-- Tabla Sube
CREATE TABLE Sube (
    idTicket INT PRIMARY KEY,
    FechaDeTicket DATE,
    ColectivoUsado INT,
    FOREIGN KEY (ColectivoUsado) REFERENCES Colectivos(idColectivo)
);

-- ============================================
-- INSERTS
-- ============================================

-- Insertar Seguros
INSERT INTO Seguros (idSeguro, Empresa, DiaDeContratacion, DiaFinDeContrato, CostoSeguro) VALUES
(1, 'La Caja', '2024-01-10', '2025-01-10', 120000),
(2, 'Sancor Seguros', '2023-06-01', '2024-06-01', 95000),
(3, 'Mapfre', '2024-03-15', '2025-03-15', 110000),
(4, 'Allianz', '2024-09-01', '2025-09-01', 105000),
(5, 'Federación Patronal', '2023-12-20', '2024-12-20', 99000),
(6, 'Zurich', '2024-05-05', '2025-05-05', 115000);

-- Insertar Localidad
INSERT INTO Localidad (idLocalidad, nombreLocalidad, tipoZona) VALUES
(1, 'Lanús', 'Zona Sur'),
(2, 'Avellaneda', 'Zona Sur'),
(3, 'Quilmes', 'Zona Sur'),
(4, 'Buenos Aires', 'Capital'),
(5, 'Lomas de Zamora', 'Zona Sur'),
(6, 'Banfield', 'Zona Sur');

-- Insertar Lineas
INSERT INTO Lineas (numeroDeLinea, nombreLinea) VALUES
(7, 'Línea 7'),
(22, 'Línea 22'),
(39, 'Línea 39'),
(45, 'Línea 45'),
(60, 'Línea 60'),
-- Línea solo de Capital para Query 4.1
(100, 'Línea 100');

-- Insertar Paradas
INSERT INTO Paradas (idParada, nombreParada, direccionParada, ParadaLocalidad) VALUES
(1, 'Parada Centro Lanús', 'Av. Hipólito Yrigoyen 2000', 1),
(2, 'Parada Estación Lanús', 'Av. 9 de Julio 1500', 1),
(3, 'Parada Avellaneda Centro', 'Av. Mitre 800', 2),
(4, 'Parada Quilmes Centro', 'Av. Hipólito Yrigoyen 100', 3),
(5, 'Parada Retiro', 'Av. Ramos Mejía 1200', 4),
(6, 'Parada Plaza de Mayo', 'Av. de Mayo 500', 4),
(7, 'Parada Lomas Centro', 'Av. Meeks 500', 5),
(8, 'Parada Banfield', 'Av. Hipólito Yrigoyen 3000', 6),
-- Paradas adicionales de Capital para Query 4.1
(9, 'Parada Palermo', 'Av. Santa Fe 3000', 4),
(10, 'Parada Belgrano', 'Av. Cabildo 2000', 4);

-- Insertar Rutas
INSERT INTO Rutas (idRutas, nombreRuta, idLinea) VALUES
(1, 'Ruta A - Lanús a Capital', 7),
(2, 'Ruta B - Capital a Lanús', 7),
(3, 'Ruta A - Avellaneda a Quilmes', 22),
(4, 'Ruta B - Quilmes a Avellaneda', 22),
(5, 'Ruta A - Capital a Zona Sur', 39),
(6, 'Ruta B - Zona Sur a Capital', 39),
(7, 'Ruta A - Lomas a Capital', 45),
(8, 'Ruta B - Capital a Lomas', 45),
(9, 'Ruta A - Banfield a Capital', 60),
(10, 'Ruta B - Capital a Banfield', 60),
-- Rutas solo de Capital para Query 4.1
(11, 'Ruta A - Capital Centro', 100),
(12, 'Ruta B - Capital Norte', 100);

-- Insertar RutaParada
INSERT INTO RutaParada (idRuta, idParada, orden) VALUES
(1, 2, 1),
(1, 1, 2),
(1, 5, 3),
(1, 6, 4),
(2, 6, 1),
(2, 5, 2),
(2, 1, 3),
(2, 2, 4),
(3, 3, 1),
(3, 4, 2),
(5, 5, 1),
(5, 6, 2),
(5, 1, 3),
(6, 1, 1),
(6, 6, 2),
(6, 5, 3),
(7, 7, 1),
(7, 5, 2),
(8, 5, 1),
(8, 7, 2),
(9, 8, 1),
(9, 5, 2),
(10, 5, 1),
(10, 8, 2),
-- RutaParada para rutas solo de Capital (Query 4.1)
(11, 5, 1),
(11, 6, 2),
(11, 9, 3),
(12, 9, 1),
(12, 10, 2),
(12, 6, 3);

-- Insertar Colectivos
INSERT INTO Colectivos (idColectivo, Anio, Modelo, Patente, Vtv, Capacidad, AireAcondicionado, SeguroDelColectivo, LineaDelColectivo) VALUES
(1, 2020, 'Mercedes-Benz OF-1722', 'ABC123', '2024-12-15', 45, 1, 1, 7),
(2, 2019, 'Mercedes-Benz OF-1722', 'DEF456', '2024-11-20', 45, 1, 2, 7),
(3, 2015, 'Mercedes-Benz OF-1418', 'GHI789', '2025-01-10', 40, 0, 3, 22),
(4, 2018, 'Mercedes-Benz OF-1722', 'JKL012', '2024-10-05', 45, 1, 4, 22),
(5, 2012, 'Mercedes-Benz OF-1418', 'MNO345', '2024-12-30', 40, 0, 5, 39),
(6, 2021, 'Mercedes-Benz OF-1722', 'PQR678', '2025-02-15', 45, 1, 6, 39),
(7, 2016, 'Mercedes-Benz OF-1418', 'STU901', '2024-11-25', 40, 1, 1, 45),
(8, 2017, 'Mercedes-Benz OF-1722', 'VWX234', '2025-01-20', 45, 1, 2, 45),
(9, 2014, 'Mercedes-Benz OF-1418', 'YZA567', '2024-12-10', 40, 0, 3, 60),
(10, 2022, 'Mercedes-Benz OF-1722', 'BCD890', '2025-03-01', 45, 1, 4, 60);

-- Colectivos con VTVs próximas a vencer (para Query 1) - Fechas dentro de los próximos 30 días
INSERT INTO Colectivos (idColectivo, Anio, Modelo, Patente, Vtv, Capacidad, AireAcondicionado, SeguroDelColectivo, LineaDelColectivo)
SELECT 11, 2018, 'Mercedes-Benz OF-1722', 'XYZ111', DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 45, 1, 5, 7
UNION ALL
SELECT 12, 2019, 'Mercedes-Benz OF-1418', 'XYZ222', DATEADD(DAY, 25, CAST(GETDATE() AS DATE)), 40, 0, 6, 22
UNION ALL
SELECT 15, 2020, 'Mercedes-Benz OF-1722', 'VTV001', DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), 45, 1, 1, 39
UNION ALL
SELECT 16, 2019, 'Mercedes-Benz OF-1418', 'VTV002', DATEADD(DAY, 20, CAST(GETDATE() AS DATE)), 40, 0, 2, 45;

-- Colectivos sin seguros (para Query 6)
INSERT INTO Colectivos (idColectivo, Anio, Modelo, Patente, Vtv, Capacidad, AireAcondicionado, SeguroDelColectivo, LineaDelColectivo) VALUES
(13, 2013, 'Mercedes-Benz OF-1418', 'SIN001', '2025-06-15', 40, 0, NULL, 39),
(14, 2015, 'Mercedes-Benz OF-1722', 'SIN002', '2025-07-20', 45, 1, NULL, 45),
(17, 2011, 'Mercedes-Benz OF-1418', 'SIN003', '2025-08-10', 40, 0, NULL, 60);

-- Colectivos solo de Capital para Query 4.1
INSERT INTO Colectivos (idColectivo, Anio, Modelo, Patente, Vtv, Capacidad, AireAcondicionado, SeguroDelColectivo, LineaDelColectivo) VALUES
(18, 2020, 'Mercedes-Benz OF-1722', 'CAP001', '2025-04-15', 45, 1, 1, 100),
(19, 2021, 'Mercedes-Benz OF-1722', 'CAP002', '2025-05-20', 45, 1, 2, 100);

-- Insertar Sube (Tickets)
INSERT INTO Sube (idTicket, FechaDeTicket, ColectivoUsado) VALUES
(1, '2024-10-01', 1),
(2, '2024-10-01', 2),
(3, '2024-10-01', 3),
(4, '2024-10-01', 4),
(5, '2024-10-01', 5),
(6, '2024-10-01', 6),
(7, '2024-10-01', 7),
(8, '2024-10-01', 8),
(9, '2024-10-01', 9),
(10, '2024-10-01', 10),
(11, '2024-10-02', 1),
(12, '2024-10-02', 2),
(13, '2024-10-02', 3),
(14, '2024-10-02', 4),
(15, '2024-10-02', 5),
(16, '2024-10-15', 1),
(17, '2024-10-15', 2),
(18, '2024-10-15', 3),
(19, '2024-10-15', 6),
(20, '2024-10-15', 7),
(21, '2024-11-01', 1),
(22, '2024-11-01', 2),
(23, '2024-11-01', 3),
(24, '2024-11-01', 4),
(25, '2024-11-01', 5),
(26, '2024-11-01', 6),
(27, '2024-11-01', 7),
(28, '2024-11-01', 8),
(29, '2024-11-01', 9),
(30, '2024-11-01', 10),
(31, '2024-11-15', 1),
(32, '2024-11-15', 2),
(33, '2024-11-15', 3),
(34, '2024-11-15', 4),
(35, '2024-11-15', 5);

-- Tickets con fecha de hoy para demostrar Query 3 (más usuarios diarios)
INSERT INTO Sube (idTicket, FechaDeTicket, ColectivoUsado)
SELECT 36, CAST(GETDATE() AS DATE), 1
UNION ALL SELECT 37, CAST(GETDATE() AS DATE), 2
UNION ALL SELECT 38, CAST(GETDATE() AS DATE), 3
UNION ALL SELECT 39, CAST(GETDATE() AS DATE), 4
UNION ALL SELECT 40, CAST(GETDATE() AS DATE), 5
UNION ALL SELECT 41, CAST(GETDATE() AS DATE), 6
UNION ALL SELECT 42, CAST(GETDATE() AS DATE), 7
UNION ALL SELECT 43, CAST(GETDATE() AS DATE), 8
UNION ALL SELECT 44, CAST(GETDATE() AS DATE), 11
UNION ALL SELECT 45, CAST(GETDATE() AS DATE), 12
-- Más tickets de hoy para mostrar usuarios diarios por línea
UNION ALL SELECT 46, CAST(GETDATE() AS DATE), 1
UNION ALL SELECT 47, CAST(GETDATE() AS DATE), 1
UNION ALL SELECT 48, CAST(GETDATE() AS DATE), 1
UNION ALL SELECT 49, CAST(GETDATE() AS DATE), 2
UNION ALL SELECT 50, CAST(GETDATE() AS DATE), 2
UNION ALL SELECT 51, CAST(GETDATE() AS DATE), 3
UNION ALL SELECT 52, CAST(GETDATE() AS DATE), 3
UNION ALL SELECT 53, CAST(GETDATE() AS DATE), 3
UNION ALL SELECT 54, CAST(GETDATE() AS DATE), 4
UNION ALL SELECT 55, CAST(GETDATE() AS DATE), 4
UNION ALL SELECT 56, CAST(GETDATE() AS DATE), 5
UNION ALL SELECT 57, CAST(GETDATE() AS DATE), 5
UNION ALL SELECT 58, CAST(GETDATE() AS DATE), 6
UNION ALL SELECT 59, CAST(GETDATE() AS DATE), 7
UNION ALL SELECT 60, CAST(GETDATE() AS DATE), 8
UNION ALL SELECT 61, CAST(GETDATE() AS DATE), 9
UNION ALL SELECT 62, CAST(GETDATE() AS DATE), 10
UNION ALL SELECT 63, CAST(GETDATE() AS DATE), 15
UNION ALL SELECT 64, CAST(GETDATE() AS DATE), 16
-- Tickets para línea 100 (solo Capital) para Query 3
UNION ALL SELECT 65, CAST(GETDATE() AS DATE), 18
UNION ALL SELECT 66, CAST(GETDATE() AS DATE), 19
UNION ALL SELECT 67, CAST(GETDATE() AS DATE), 18;

-- ============================================
-- QUERIES
-- ============================================

-- ============================================
-- 1. VTVs POR VENCER (30 días antes)
-- ============================================
-- Muestra los colectivos cuyas VTVs vencen en los próximos 30 días
SELECT 
    idColectivo,
    Patente,
    Modelo,
    Vtv,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), Vtv) AS dias_restantes
FROM Colectivos
WHERE Vtv BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
ORDER BY Vtv ASC;

-- ============================================
-- 2. COLECTIVOS CON MÁS DE 10 AÑOS
-- ============================================
-- Muestra los colectivos que tienen más de 10 años de antigüedad
SELECT 
    idColectivo,
    Patente,
    Modelo,
    Anio,
    YEAR(GETDATE()) - Anio AS años_antiguedad
FROM Colectivos
WHERE YEAR(GETDATE()) - Anio > 10
ORDER BY años_antiguedad DESC;

-- ============================================
-- 3. CANTIDAD DE USUARIOS POR LÍNEA
-- ============================================
-- Muestra la cantidad de usuarios que usaron esa linea en el dia y en el mes.
SELECT 
    l.numeroDeLinea,
    l.nombreLinea,
    COUNT(DISTINCT CASE WHEN CAST(s.FechaDeTicket AS DATE) = CAST(GETDATE() AS DATE) THEN s.idTicket END) AS usuarios_hoy,
    COUNT(DISTINCT CASE WHEN YEAR(s.FechaDeTicket) = YEAR(GETDATE()) 
                        AND MONTH(s.FechaDeTicket) = MONTH(GETDATE()) 
                        THEN s.idTicket END) AS usuarios_mes_actual
FROM Lineas l
LEFT JOIN Colectivos c ON l.numeroDeLinea = c.LineaDelColectivo
LEFT JOIN Sube s ON c.idColectivo = s.ColectivoUsado
GROUP BY l.numeroDeLinea, l.nombreLinea
ORDER BY l.numeroDeLinea;

-- ============================================
-- 4. COLECTIVOS QUE PASAN DE CAPITAL A PROVINCIA Y VICEVERSA
-- ============================================
SELECT 
    c.idColectivo,
    c.Patente,
    c.Modelo,
    l.nombreLinea,
    STUFF((
        SELECT ' - ' + loc2.tipoZona
        FROM (
            SELECT DISTINCT loc3.tipoZona
            FROM Rutas r3
            INNER JOIN RutaParada rp3 ON r3.idRutas = rp3.idRuta
            INNER JOIN Paradas p3 ON rp3.idParada = p3.idParada
            INNER JOIN Localidad loc3 ON p3.ParadaLocalidad = loc3.idLocalidad
            WHERE r3.idLinea = l.numeroDeLinea
        ) AS loc2
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS zonas_recorridas
FROM Colectivos c
INNER JOIN Lineas l ON c.LineaDelColectivo = l.numeroDeLinea
INNER JOIN Rutas r ON l.numeroDeLinea = r.idLinea
INNER JOIN RutaParada rp ON r.idRutas = rp.idRuta
INNER JOIN Paradas p ON rp.idParada = p.idParada
INNER JOIN Localidad loc ON p.ParadaLocalidad = loc.idLocalidad
GROUP BY c.idColectivo, c.Patente, c.Modelo, l.numeroDeLinea, l.nombreLinea
HAVING COUNT(DISTINCT loc.tipoZona) > 1
ORDER BY c.idColectivo;

-- ============================================
-- 4.1. COLECTIVOS QUE SOLO HACEN RUTAS DE CAPITAL
-- ============================================
SELECT 
    c.idColectivo,
    c.Patente,
    c.Modelo,
    l.nombreLinea
FROM Colectivos c
INNER JOIN Lineas l ON c.LineaDelColectivo = l.numeroDeLinea
INNER JOIN Rutas r ON l.numeroDeLinea = r.idLinea
INNER JOIN RutaParada rp ON r.idRutas = rp.idRuta
INNER JOIN Paradas p ON rp.idParada = p.idParada
INNER JOIN Localidad loc ON p.ParadaLocalidad = loc.idLocalidad
GROUP BY c.idColectivo, c.Patente, c.Modelo, l.numeroDeLinea, l.nombreLinea
HAVING COUNT(DISTINCT loc.tipoZona) = 1 
   AND MAX(loc.tipoZona) = 'Capital'
ORDER BY c.idColectivo;

-- ============================================
-- 4.2. COLECTIVOS QUE SOLO HACEN RUTAS DE ZONA SUR
-- ============================================
SELECT 
    c.idColectivo,
    c.Patente,
    c.Modelo,
    l.nombreLinea
FROM Colectivos c
INNER JOIN Lineas l ON c.LineaDelColectivo = l.numeroDeLinea
INNER JOIN Rutas r ON l.numeroDeLinea = r.idLinea
INNER JOIN RutaParada rp ON r.idRutas = rp.idRuta
INNER JOIN Paradas p ON rp.idParada = p.idParada
INNER JOIN Localidad loc ON p.ParadaLocalidad = loc.idLocalidad
GROUP BY c.idColectivo, c.Patente, c.Modelo, l.numeroDeLinea, l.nombreLinea
HAVING COUNT(DISTINCT loc.tipoZona) = 1 
   AND MAX(loc.tipoZona) = 'Zona Sur'
ORDER BY c.idColectivo;

-- ============================================
-- 5. CANTIDAD DE COLECTIVOS POR LÍNEA
-- ============================================
SELECT 
    l.numeroDeLinea,
    l.nombreLinea,
    COUNT(c.idColectivo) AS cantidad_colectivos
FROM Lineas l
LEFT JOIN Colectivos c ON l.numeroDeLinea = c.LineaDelColectivo
GROUP BY l.numeroDeLinea, l.nombreLinea
ORDER BY l.numeroDeLinea;

-- ============================================
-- 6. COLECTIVOS SIN SEGUROS
-- ============================================
SELECT 
    idColectivo,
    Patente,
    Modelo
FROM Colectivos
WHERE SeguroDelColectivo IS NULL;

-- ============================================
-- 7. PARADAS POR RUTA
-- ============================================
-- Muestra las paradas que hace cada ruta, ordenadas por el orden de recorrido
SELECT 
    r.idRutas AS id_ruta,
    r.nombreRuta,
    l.numeroDeLinea,
    l.nombreLinea,
    rp.orden,
    p.nombreParada,
    p.direccionParada,
    loc.nombreLocalidad,
    loc.tipoZona
FROM Rutas r
INNER JOIN Lineas l ON r.idLinea = l.numeroDeLinea
INNER JOIN RutaParada rp ON r.idRutas = rp.idRuta
INNER JOIN Paradas p ON rp.idParada = p.idParada
INNER JOIN Localidad loc ON p.ParadaLocalidad = loc.idLocalidad
ORDER BY r.idRutas, rp.orden;

