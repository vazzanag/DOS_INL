CREATE PROCEDURE [users].[SaveAppUserProfile]
	@AppUserID INT,
	@ADOID NVARCHAR(100),
	@First NVARCHAR(35), 
	@Middle NVARCHAR(35), 
	@Last NVARCHAR(50), 
	@PositionTitle NVARCHAR(200),
    @EmailAddress NVARCHAR(75), 
	@PhoneNumber NVARCHAR(50),
    @PicturePath NVARCHAR(200), 
    @CountryID INT,
    @PostID INT,	
    @DefaultBusinessUnitID INT,	
    @AppRoles NVARCHAR(MAX),
    @BusinessUnits NVARCHAR(MAX),
	@ModifiedByAppUserID INT
AS
BEGIN

	SET NOCOUNT ON;

    BEGIN TRANSACTION

    BEGIN TRY

        IF (@AppUserID IS NULL OR @AppUserID = -1) 
        BEGIN

			INSERT INTO users.AppUsers
				(ADOID, First, Middle, Last, PositionTitle, EmailAddress, PhoneNumber, PicturePath, CountryID, PostID, ModifiedByAppUserID)
			VALUES
				(@ADOID, @First, @Middle, @Last, @PositionTitle, @EmailAddress, @PhoneNumber, @PicturePath, @CountryID, @PostID, @ModifiedByAppUserID)
				
			SET @AppUserID = SCOPE_IDENTITY();

		END
		ELSE
		BEGIN

			UPDATE users.AppUsers
			SET ADOID = @ADOID,
			    First = @First,
			    Middle = @Middle,
			    Last = @Last,
			    PositionTitle = @PositionTitle,
			    EmailAddress = @EmailAddress,
			    PhoneNumber = @PhoneNumber,
			    PicturePath = @PicturePath,
			    CountryID = @CountryID,
			    PostID = @PostID
			WHERE AppUserID = @AppUserID;

		END
			   		
        IF (@AppRoles IS NOT NULL)
            EXEC users.SaveAppUserRoles @AppUserID,  @ModifiedByAppUserID, @AppRoles
			
		
        IF (@BusinessUnits IS NOT NULL)
            EXEC users.SaveAppUserBusinessUnits @AppUserID, @DefaultBusinessUnitID, @ModifiedByAppUserID, @BusinessUnits

        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
