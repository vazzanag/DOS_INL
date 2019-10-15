MERGE INTO [training].[TrainingEventTypes] TARGET
USING 
    (SELECT [Name], [Description], [CountryID], [IsActive], [ModifiedByAppUserID]
       FROM (VALUES
				('Conference', NULL, NULL, 1, 1),
				('Meeting', NULL, NULL, 1, 1),
				('Study Tour', NULL, NULL, 1,1),
				('Course', NULL, NULL, 1, 1),
				('Train-the-Trainer', NULL, NULL, 0, 1),
				('Seminar', NULL, NULL, 0, 1),
				('Workshop', NULL, NULL, 0, 1),
				('Assessment', NULL, NULL, 0, 1),
				('Best Practices Visit', NULL, NULL, 0, 1),
				('Professional Exchange', NULL, NULL, 0, 1),
				('Technical Assistance', NULL, NULL, 0, 1),
				('Symposium', NULL, NULL, 0, 1),
				('Equipment Donation', NULL, NULL, 0, 1),
				('Youth', NULL, NULL, 0, 1),
				('Exchange Program', NULL, NULL, 0, 1),
				('Sports', NULL, NULL, 0, 1),
				('Representation Event', NULL, NULL, 0, 1),
				('Indigenous', NULL, NULL, 0, 1),
				('LGBT', NULL, NULL, 0, 1),
				('Unit Vetting / Equipment Donation', NULL, NULL, 0, 1),
				('Logistics Support', NULL, NULL, 1, 1),
				('Training', NULL, NULL, 0, 1),
				('Replication', NULL, NULL, 0, 1),
				('Case Mentoring', NULL, NULL, 0, 1),
				('Operational Travel', NULL, NULL, 0, 1),
				('Vetting Only', NULL, NULL, 0, 1)               
            ) X ([Name], [Description], [CountryID], [IsActive], [ModifiedByAppUserID])
    ) AS source
ON (target.[Name] = source.[Name])
WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Name], [Description], [CountryID], [IsActive], [ModifiedByAppUserID])
    VALUES ([Name], [Description], [CountryID], [IsActive], [ModifiedByAppUserID]);
