IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'BankSystemDb')
    BEGIN
        CREATE DATABASE [BankSystemDb]
    END
GO


IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'BankSystemDb')
    BEGIN
        USE [BankSystemDb]
    END
GO

IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE NAME = 'BankAccounts')
    BEGIN
        CREATE TABLE BankAccounts
        (
	        Id INT IDENTITY(1,1) NOT NULL,
	        AccountNumber VARCHAR(12) NOT NULL,
	        LoginName VARCHAR(30) NOT NULL,
	        Password CHAR(64) NOT NULL,
	        Salt VARCHAR(40) NOT NULL,
	        Balance DECIMAL(19,2) NOT NULL,
	        DateCreated DATETIME NOT NULL
        )
    END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'spAddBankAccount')
    BEGIN
        EXEC('
            CREATE PROCEDURE spAddBankAccount
            (
                @AccountNumber VARCHAR(12),
	            @LoginName VARCHAR(30),
	            @Password CHAR(64),
	            @Salt VARCHAR(40),
	            @Balance DECIMAL(19,2),
	            @DateCreated DATETIME
            )
            AS
            BEGIN
                INSERT INTO BankAccounts (AccountNumber, LoginName, Password, Salt, Balance, DateCreated)           
                Values (@AccountNumber, @LoginName, @Password, @Salt, @Balance, @DateCreated)     
            END
        ');
    END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'spUpdateAccountBalance')
    BEGIN
        EXEC('
            CREATE PROCEDURE spUpdateAccountBalance
            (
                @Id INT,
                @AccountNumber VARCHAR(12),
	            @LoginName VARCHAR(30),
	            @Balance DECIMAL(19,2)
            )
            AS
            BEGIN
               UPDATE BankAccounts             
               SET Balance=@Balance       
               WHERE Id=@Id AND AccountNumber=@AccountNumber AND LoginName=@LoginName        
            END
        ');
    END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'spGetBankAccount')
    BEGIN
        EXEC('
            CREATE PROCEDURE spGetBankAccount
            (
                @Id INT,
                @AccountNumber VARCHAR(12),
	            @LoginName VARCHAR(30)
            )
            AS
            BEGIN
                SELECT 1 FROM BankAccounts
                WHERE Id=@Id AND AccountNumber=@AccountNumber AND LoginName=@LoginName    
            END
        ');
    END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'spGetAllBankAccounts')
    BEGIN
        EXEC('
            CREATE PROCEDURE spGetAllBankAccounts
            AS
            BEGIN
                SELECT * FROM BankAccounts ORDER BY Id
            END
        ');
    END
GO