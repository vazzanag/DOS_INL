/*
    **************************************************************************
    VettingLeahyHitResults_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingLeahyHitResults_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingLeahyHitResults] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingLeahyHitResults]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingLeahyHitResults]
				([LeahyHitResultID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Approved', 'Participant was approved by the INVEST system for training.', 1, 1),               
				(2, 'Suspended', 'Participant is currently in a suspended or process review status in the INVEST system.', 1, 1),
				(3, 'Rejected', 'Participant was rejected and not approved by the INVEST system for training.', 1, 1),
				(4, 'Canceled', 'Participant''s INVEST vetting was canceled.', 1, 1),
				(5, 'Matched', 'Participant has a valid vetting based on a previous vetting and does not need to be resubmitted to INVEST for vetting.', 1, 1)                
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingLeahyHitResults] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingLeahyHitResults]', RESEED)
GO





