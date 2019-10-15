UPDATE vetting.PersonsVetting SET Name1 = CONVERT(varchar, Name1) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
								  Name2 = CONVERT(varchar, Name2) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
								  Name3 = CONVERT(varchar, Name3) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
								  Name4 = CONVERT(varchar, Name4) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
								  Name5 = CONVERT(varchar, Name5) COLLATE SQL_Latin1_General_Cp1251_CS_AS
	FROM  vetting.PersonsVetting