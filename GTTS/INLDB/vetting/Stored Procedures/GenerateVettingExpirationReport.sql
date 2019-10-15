CREATE PROCEDURE [vetting].[GenerateVettingExpirationReport]
	@PostID INT,
	@GeneratedDate DATE = NULL
AS
BEGIN
    IF @GeneratedDate IS NULL
		SET @GeneratedDate = GETDATE()
	SELECT DISTINCT pv.Name1 AS [First Name], 
		   CASE WHEN CHARINDEX(pv.Name3, p.LastNames) = 1 THEN ISNULL(pv.Name2,'') ELSE ISNULL(pv.Name2,'')+' ' +ISNULL(pv.Name3,'') END AS [Second Name],
		   CASE WHEN CHARINDEX(pv.Name3, p.LastNames) = 1 THEN pv.Name3 ELSE ISNULL(pv.Name4,'') END AS [Last Name 1],
		   CASE WHEN CHARINDEX(pv.Name3, p.LastNames) = 1 THEN ISNULL(pv.Name4,'')+' ' +ISNULL(pv.Name5,'') ELSE ISNULL(pv.Name5,'') END AS [Last Name 2],
		   CONVERT(VARCHAR(10),p.DOB,101) AS DOB,
		   p.NationalID AS Cedula, u.UnitAcronym AS UnitDesc, 
		   lh.ExpiresDate AS [Vetting Expiration Date],
		   DATEDIFF(day, @GeneratedDate, lh.ExpiresDate) AS [Days to Expire]
		 FROM vetting.PersonsVetting pv
	INNER JOIN vetting.VettingBatches b ON pv.VettingBatchID = b.VettingBatchID
	   INNER JOIN persons.PersonsUnitLibraryInfo pui ON pv.PersonsUnitLibraryInfoID = pui.PersonsUnitLibraryInfoID
	   INNER JOIN unitlibrary.Units u ON pui.UnitID = u.UnitID
	   INNER JOIN persons.Persons p ON pui.PersonID = p.PersonID
	   INNER JOIN [location].Posts post ON b.CountryID = post.CountryID
	   INNER JOIN vetting.LeahyVettingHits lh ON pv.PersonsVettingID = lh.PersonsVettingID
		 WHERE pv.VettingPersonStatusID = 2
			AND DATEDIFF(day, @GeneratedDate, lh.ExpiresDate) < 60
			AND post.PostID = @PostID
END	
