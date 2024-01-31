CREATE DATABASE DotNetCourseDatabase
GO

USE DotNetCourseDatabase
GO

CREATE SCHEMA TutorialAppSchema
GO

CREATE TABLE TutorialAppSchema.Computer
(
    ComputerId INT IDENTITY(1,1) PRIMARY KEY,
    Motherboard NVARCHAR(255),
    CPUCore INT,
    HasWiFi BIT,
    HasLTE BIT,
    ReleaseDate DATETIME2,
    Price DECIMAL(18,4),
    Videocard NVARCHAR(50),
)
GO

SELECT 
    [ComputerId],
    [Motherboard],
    ISNULL([CPUCores], 0),
    [HasWifi],
    [HasLTE],
    [ReleaseDate],
    [Price],
    [VideoCard]
FROM TutorialAppSchema.Computer
ORDER BY HasWiFi, ReleaseDate DESC
GO

--SET IDENTITY_INSERT TutorialAppSchema.Computer ON
--SET IDENTITY_INSERT TutorialAppSchema.Computer OFF

INSERT INTO TutorialAppSchema.Computer(
    [Motherboard],
    [CPUCores],
    [HasWifi],
    [HasLTE],
    [ReleaseDate],
    [Price],
    [VideoCard]
) VALUES (
    'Sample-Motherboard',
    4,
    1,
    0,
    '2022-01-01',
    1000,
    'Sample-Videocard'
)
GO

DELETE FROM TutorialAppSchema.Computer WHERE ComputerId = 1
GO

UPDATE TutorialAppSchema.Computer SET CPUCores = 4 WHERE ComputerId = 2
GO

UPDATE TutorialAppSchema.Computer SET CPUCores = 2 WHERE ReleaseDate < '2017-01-01'
GO

UPDATE TutorialAppSchema.Computer SET CPUCores = NULL WHERE ReleaseDate >= '2017-01-01'
GO
