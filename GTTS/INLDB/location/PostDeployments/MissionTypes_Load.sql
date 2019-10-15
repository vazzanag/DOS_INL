/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[MissionTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[MissionTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[MissionTypes]
				([MissionTypeID]
				,[MissionTypeCode]
				,[Name]
				,[Description]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES
				(1, N'BL', N'Bilateral Mission', N'A bilateral mission, also referred to as a permanent bilateral mission, is a delegation established and maintained by the U.S. government to conduct normal continuing relations between the government of the United States and the government of one other country or authority. In some instances a single mission may maintain relations with more than one country or authority, but the relations are always one-to-one. The mission is comprised of all U.S. agencies (except those agencies under the command of a U.S. area military commander) represented in the country or area, such as USAID, Foreign Agricultural Service, Foreign Commercial Service, Peace Corps, military groups, law enforcement, and Defense attachés, as well as the traditional functions concerned with political, economic, commercial, labor, consular, science, management, and related affairs.', 1, 1),
				(2, N'ML', N'Multilateral Mission', N'A multilateral mission, also referred to as a permanent multilateral mission, is a diplomatic delegation established and maintained by the U.S. government to conduct relations between the Government of the United States and two or more foreign governments or authorities collectively or an international organization.', 1, 1),
				(3, N'BLS', N'Special Bilateral Mission', N'A special bilateral mission is a type of bilateral mission established to achieve a diplomatic purpose of a special character distinct from the normal continuing diplomatic functions. A special bilateral mission has a purpose which has a logical end-point or conclusion, such as negotiation of an agreement.', 1, 1),
				(4, N'MLS', N'Special Multilateral Mission', N'A special multilateral mission is a type of multilateral mission established to achieve a diplomatic purpose of a special character distinct from the normal continuing diplomatic functions. A special multilateral mission has a purpose which has a logical end-point or conclusion, such as negotiation of an international agreement.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[MissionTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[MissionTypes]', RESEED)
GO