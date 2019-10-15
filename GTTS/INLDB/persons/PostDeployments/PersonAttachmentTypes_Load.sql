MERGE INTO [persons].[PersonAttachmentTypes] TARGET
USING 
    (SELECT [Name], [Description], [IsActive], [ModifiedByAppUserID]
       FROM (VALUES
				('Award', null, 1, 1),
				('Resume', null, 1, 1),
				('Participant Performance', null, 1, 1),
				('Instructor Review', null, 1, 1),
				('Certification', null, 1, 1),
                ('National ID', 'Supporting docuemnts for proof of National ID', 1, 1),
                ('Other', null, 1, 1)
            ) X ([Name], [Description], [IsActive], [ModifiedByAppUserID])
    ) AS source
ON (target.[Name] = source.[Name])
WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Name], [Description], [IsActive], [ModifiedByAppUserID])
    VALUES ([Name], [Description], [IsActive], [ModifiedByAppUserID]);