CREATE VIEW [persons].[PersonLanguagesView]
AS 
	 SELECT PersonID, pl.LanguageID, pl.LanguageProficiencyID, l.Code AS LanguageCode, l.[Description] AS LanguageDescription,
			lp.Code AS LanguageProficiencyCode, lp.[Description] AS LanguageProficiencyDescription, pl.ModifiedByAppUserID		   
	   FROM persons.PersonLanguages pl
 INNER JOIN [location].Languages l ON pl.LanguageID = l.LanguageID
  LEFT JOIN [location].LanguageProficiencies lp ON pl.LanguageProficiencyID = lp.LanguageProficiencyID