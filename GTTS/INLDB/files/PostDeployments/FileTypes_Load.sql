MERGE INTO [files].[FileTypes] TARGET
USING 
    (SELECT [Name], [Extension], [Description], [IsActive], [ModifiedByAppUserID]
       FROM (VALUES
				('Text File', '.txt', '', 1, 1),
				('PDF - Portable Document Format', '.pdf', '', 1, 1),
				('Microsoft Word 97-2003', '.doc', '', 1, 1),
				('Microsoft Word 2007-2013', '.docx', '', 1, 1),
				('Microsoft Excel 97-2003', '.xls', '', 1, 1),
				('Microsoft Excel 2007-2013', '.xlsx', '', 1, 1),
				('Microsoft Powerpoint 97-2003', '.ppt', '', 1, 1),
				('Microsoft Powerpoint 2007-2013', '.pptx', '', 1, 1),
				('Rich Text Format', '.rtf', '', 1, 1),
				('Web Page', '.htm, .html', '', 1, 1),
				('JPEG Image', '.jpg, .jpeg', '', 1, 1),
				('GIF Image', '.gif', '', 1, 1),
				('Bitmap Image', '.bmp', '', 1, 1),
				('PNG Image', '.png', '', 1, 1),
				('Email', '.eml', '', 1, 1),
				('Unknown', '*.*', 'Unknown', 1, 1),
                ('National ID', '.gif, .png, .bmp, .jpg, .jpeg, .pdf, .doc, .docx, .xls, .xlsx', 'Supporting docuemnts for proof of National ID', 1, 1)
            ) X ([Name], [Extension], [Description], [IsActive], [ModifiedByAppUserID])
    ) AS source
ON (target.[Name] = source.[Name])
WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Name], [Extension], [Description], [IsActive], [ModifiedByAppUserID])
    VALUES ([Name], [Extension], [Description], [IsActive], [ModifiedByAppUserID]);

