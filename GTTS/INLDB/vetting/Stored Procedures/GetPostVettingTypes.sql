CREATE PROCEDURE [vetting].[GetPostVettingTypes]
    @PostID INT
AS
BEGIN

    SELECT * 
      FROM vetting.PostVettingTypesView
    WHERE PostID = @PostID;

END;
