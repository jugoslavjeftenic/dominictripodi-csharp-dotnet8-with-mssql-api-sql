USE DotNetCourseDatabase
GO

SELECT
    [Users].[UserId],
    [Users].[FirstName] + ' ' + [Users].[LastName] AS [Full Name],
    [Users].[Email],
    [Users].[Gender],
    [Users].[Active],
    [UserJobInfo].[JobTitle],
    [UserJobInfo].[Department]
FROM TutorialAppSchema.Users AS Users
    JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
WHERE [Users].[Active] = 0
ORDER BY [Users].[UserId] DESC
GO

DELETE FROM TutorialAppSchema.UserJobInfo WHERE UserId > 500
GO

SELECT
    [Users].[UserId],
    [Users].[FirstName] + ' ' + [Users].[LastName] AS [Full Name],
    [Users].[Email],
    [Users].[Gender],
    [Users].[Active],
    [UserJobInfo].[JobTitle],
    [UserJobInfo].[Department]
FROM TutorialAppSchema.Users AS Users
    LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
WHERE [Users].[Active] = 1
ORDER BY [Users].[UserId] DESC
GO

SELECT
    [Users].[UserId],
    [Users].[FirstName] + ' ' + [Users].[LastName] AS [Full Name],
    [Users].[Email],
    [Users].[Gender],
    [Users].[Active],
    [UserJobInfo].[JobTitle],
    [UserJobInfo].[Department],
    [UserSalary].[Salary]
FROM TutorialAppSchema.Users AS Users
    JOIN TutorialAppSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
    LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
WHERE [Users].[Active] = 1
ORDER BY [Users].[UserId] DESC
GO

DELETE FROM TutorialAppSchema.UserSalary WHERE UserId BETWEEN 250 AND 750
GO

SELECT * FROM TutorialAppSchema.UserSalary AS UserSalary
    WHERE EXISTS (
        SELECT * FROM TutorialAppSchema.UserJobInfo AS UserJobInfo
            WHERE UserJobInfo.UserId = UserSalary.UserId
    ) AND UserId <> 7
GO

SELECT * FROM TutorialAppSchema.UserSalary
-- UNION -> Distinct between two data sets
UNION ALL
SELECT * FROM TutorialAppSchema.UserSalary
GO

CREATE CLUSTERED INDEX cix_UserSalary_UserId ON TutorialAppSchema.UserSalary(UserId)
GO

CREATE NONCLUSTERED INDEX ix_UserJobInfo_JobTitle ON TutorialAppSchema.UserJobInfo(JobTitle)
INCLUDE (Department)
GO

CREATE NONCLUSTERED INDEX fix_Users_Active ON TutorialAppSchema.Users(Active)
INCLUDE ([Email], [FirstName], [LastName])
WHERE Active = 1
GO

SELECT
    ISNULL([UserJobInfo].[Department], 'No Department Listed') AS Department,
    SUM([UserSalary].[Salary]) AS Salary,
    MIN([UserSalary].[Salary]) AS MaxSalary,
    MAX([UserSalary].[Salary]) AS MinSalary,
    AVG([UserSalary].[Salary]) AS AvgSalary,
    COUNT(*) AS [People In Department],
    STRING_AGG(Users.UserId, ', ') AS UserIds
FROM TutorialAppSchema.Users AS Users
    JOIN TutorialAppSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
    LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
WHERE [Users].[Active] = 1
GROUP BY [UserJobInfo].[Department]
ORDER BY ISNULL([UserJobInfo].[Department], 'No Department Listed') DESC
GO

SELECT GETDATE()
GO

SELECT DATEADD(YEAR, -5, GETDATE())
GO

SELECT DATEDIFF(MINUTE, GETDATE(), DATEADD(YEAR, -5, GETDATE()))
GO

ALTER TABLE TutorialAppSchema.UserSalary ADD AvgSalary DECIMAL(18,4)
GO

UPDATE UserSalary
SET UserSalary.AvgSalary = UserSalary.AvgSalary
FROM TutorialAppSchema.UserSalary AS UserSalary
    LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = UserSalary.UserId
    CROSS APPLY (
        SELECT ISNULL([UserJobInfo2].[Department], 'No Department Listed') AS Department,
            AVG([UserSalary2].[Salary]) AS AvgSalary
            FROM TutorialAppSchema.UserSalary AS UserSalary2
                LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
                    ON UserJobInfo2.UserId = UserSalary2.UserId
            WHERE ISNULL([UserJobInfo2].[Department], 'No Department Listed') = ISNULL([UserJobInfo].[Department], 'No Department Listed')
            GROUP BY [UserJobInfo2].[Department]
    ) AS DepartmentAverage
GO

