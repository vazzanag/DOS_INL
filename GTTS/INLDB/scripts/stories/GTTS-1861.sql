
-- Due to a bad MERGE script, previous database deployments were duplicating USPartnerAgencies.
-- This script is to dedupe and reconcile.

IF EXISTS (
		SELECT Name, IsActive, COUNT(*)
		FROM unitlibrary.USPartnerAgencies
		GROUP BY Name, IsActive HAVING COUNT(*) > 1
	)
BEGIN
	BEGIN TRANSACTION

	BEGIN TRY

		DECLARE @Deduper TABLE (
			AgencyID INT,
			Name NVARCHAR(100),
			Initials NVARCHAR(50),
			IsActive BIT
		);

		INSERT INTO @Deduper
		SELECT MIN(AgencyID) AS AgencyID, Name, Initials, IsActive
		FROM unitlibrary.USPartnerAgencies
		GROUP BY Name, Initials, IsActive

		UPDATE tpa
		SET tpa.AgencyID = d.AgencyID
		FROM training.TrainingEventUSPartnerAgencies tpa
		INNER JOIN unitlibrary.USPartnerAgencies pa
			ON pa.AgencyID = tpa.AgencyID
		INNER JOIN @Deduper d
			ON d.Name = pa.Name
			AND d.Initials = pa.Initials
			AND d.IsActive = pa.IsActive

		DELETE unitlibrary.USPartnerAgencies
		WHERE AgencyID NOT IN (SELECT AgencyID FROM @Deduper)

		COMMIT

	END TRY
	BEGIN CATCH

		PRINT ERROR_MESSAGE()
		ROLLBACK

	END CATCH
END

