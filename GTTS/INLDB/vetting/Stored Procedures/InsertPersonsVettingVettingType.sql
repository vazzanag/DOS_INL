CREATE PROCEDURE [vetting].[InsertPersonsVettingVettingType]
	@VettingBatchID BIGINT, 
	@ModifiedByAppUserID INT,
	@PostID BIGINT
AS
BEGIN
	INSERT INTO vetting.PersonsVettingVettingTypes(PersonsVettingID,VettingTypeID, ModifiedByAppUserID)
        SELECT pv.PersonsVettingID, pt.VettingTypeID, @ModifiedByAppUserID
	      FROM vetting.PersonsVetting pv
    CROSS JOIN vetting.PostVettingTypes pt
	 LEFT JOIN vetting.PersonsVettingVettingTypes pvt ON pv.PersonsVettingID = pvt.PersonsVettingID 
                                                     AND pt.VettingTypeID = pvt.VettingTypeID 
	     WHERE pvt.PersonsVettingID IS NULL 
           AND pv.VettingBatchID = @VettingBatchID
           AND pt.PostID = @PostID
           AND pt.IsActive = 1;

	/*skip the ones with leahy type Canceled, Rejected, or Matched */
	UPDATE vt SET vt.CourtesyVettingSkipped = 1, vt.CourtesyVettingSkippedComments = 'Skipped since leahy result is: '+r.Code
		FROM vetting.PersonsVettingVettingTypes vt
	  INNER JOIN [vetting].[LeahyVettingHits] lh on vt.PersonsVettingID = lh.PersonsVettingID
	  LEFT JOIN [vetting].[VettingLeahyHitResults] r on lh.LeahyHitResultID = r.LeahyHitResultID
			WHERE ISNULL(r.[Code],'') IN ('Rejected','Canceled','Matched')

	SELECT * from vetting.PersonsVettingView WHERE VettingBatchID = @VettingBatchID
END
