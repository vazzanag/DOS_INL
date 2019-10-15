/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[PostTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[PostTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[PostTypes]
				([PostTypeID]
				,[PostTypeCode]
				,[Name]
				,[Description]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES
				(1, N'AIT', N'AIT', N'AIT Taiwan, a private non-profit corporation, provides consular services and maintains commercial, cultural, and other relations between the U.S. and the people of Taiwan.  AIT maintains staff at two locations in Taiwan: a main facility in Taipei and a branch office in Kaohsiung.', 1, 1),
				(2, N'APP', N'American Presence Post', N'An American Presence Post is a small diplomatic and consular presence of the U.S. government in a foreign country.  APPs are legally consulates, and usually employ one U.S. direct-hire officer with no Locally Employed Staff. ', 1, 1),
				(3, N'BO', N'Branch Office', N'An Embassy Branch Office is part of an embassy''s operations that is located and staffed in a different city than the main embassy.', 1, 1),
				(4, N'C', N'Consulate', N'A Consulate is the office and staff of a Consul, who is a diplomatic representative of the United States government, subordinate to an Ambassador, operating from a facility located within a major city of a foreign country.', 1, 1),
				(5, N'CG', N'Consulate General', N'A Consulate General is the office and staff of a Consul General, who is a senior diplomatic representative of the United States government, subordinate to an Ambassador, holding Chief of Mission (COM) authority, operating from a facility located within a major city of a foreign country.', 1, 1),
				(6, N'E', N'Embassy', N'An Embassy is the office and staff of an ambassador, who is the principal diplomatic representative of the United States government, holding Chief of Mission (COM) authority, operating from a facility located within the capital city of a foreign country.', 1, 1),
				(7, N'INT', N'US Interest Section', N'A U.S. Interest Section is a diplomatic and consular presence of the U.S. government, structurally and functionally similar to an embassy, which operates under the auspices of a protecting power in a country with which the United States has no diplomatic relations.  The senior U.S. officer is the equivalent of a Consul or Consul General, not an Ambassador, but holds Chief of Mission (COM) authority.', 1, 1),
				(8, N'M', N'Mission Office', N'A Mission Office is the office and staff of a Mission to an International Organization or a Special Mission.', 1, 1),
				(9, N'SDP', N'Specially Designated Post', N'A Specially Designated Post is an establishment that has a purpose that is not primarily diplomatic or consular in nature; it considered to be a post for administrative purposes but is not considered a U.S. Diplomatic or Consular establishment.  Examples of specially designated posts include AIT as well as foreign extensions of Department Domestic Organizations having specialized mission support purposes, such as the Yokohama Regional Language School and the European Logistical Support Office, which are not collocated with diplomatic or consular posts.', 1, 1),
				(10, N'USLO', N'U.S. Liaison Office', N'A U.S. Liaison Office is the precursor to the establishment of an embassy.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[PostTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[PostTypes]', RESEED)
GO