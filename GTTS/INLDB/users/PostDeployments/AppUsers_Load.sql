/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [users].[AppUsers] ON
GO

/*	Turn off constraints	 */
ALTER TABLE [users].[AppUsers]
	NOCHECK CONSTRAINT [FK_AppUsers_AppUsers_ModifiedByAppUserID]; 
ALTER TABLE [users].[AppUsers]
	NOCHECK CONSTRAINT [FK_AppUsers_Countries]; 

IF (NOT EXISTS(SELECT * FROM users.AppUsers))
BEGIN

    INSERT INTO users.AppUsers
	    (AppUserID, ADOID, [First], [Middle], [Last], [ModifiedByAppUserID], PhoneNumber, PositionTitle, CountryID, PostID) 
    VALUES 
        (1, '00000000-0000-0000-0000-000000000000', 'SYSTEM', 'S', 'SYSTEM', 1, '', '', 2254, NULL),
        (2, '00000000-0000-0000-0000-000000000001', 'ONBOARDING', 'O', 'ONBOARDING', 1, '', '', 2254, NULL),
        (3, '00000000-0000-0000-0000-000000000002', 'MIGRATION', 'M', 'MIGRATION', 1, '', '', 2254, NULL)        
END
GO


/*	Turn on constraints			*/
ALTER TABLE users.AppUsers
	CHECK CONSTRAINT [FK_AppUsers_AppUsers_ModifiedByAppUserID];
ALTER TABLE [users].[AppUsers]
	CHECK CONSTRAINT [FK_AppUsers_Countries];  

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT users.AppUsers OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('users.AppUsers', RESEED, 101)
GO