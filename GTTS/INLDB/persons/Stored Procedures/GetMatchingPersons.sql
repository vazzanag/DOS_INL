CREATE PROCEDURE [persons].[GetMatchingPersons]
	@FirstMiddleNames NVARCHAR(50),
	@LastNames NVARCHAR(50),
	@DOB DATETIME,
	@POBCityID int, 
	@Gender CHAR(1),
	@NationalID NVARCHAR(50),
	@ExactMatch BIT = 1
AS
BEGIN
	IF (@ExactMatch = 1)
		BEGIN
			SELECT PersonID,  
				   FirstMiddleNames,
				   LastNames,
				   DOB,
				   POBCityID,
				   Gender,
				   NationalID,
				   IsUSCitizen,
				   ResidenceLocationID,
				   ContactEmail,
				   ContactPhone,
				   HighestEducationID,
				   EnglishLanguageProficiencyID,
				   PassportNumber,
				   PassportExpirationDate,
				   PassportIssuingCountryID,
				   MatchCompletely = 1,
				   POBCityName,
				   POBStateName,
				   POBCountryName,
				   PersonLanguagesJSON,
				   UnitID,
				   RankID,
				   UnitMainAgencyID,
				   IsLeahyVettingReq,
				   IsVettingReq,
				   IsValidated,
				   HostNationPOCEmail,
				   HostNationPOCName,
				   PoliceMilSecID,
				   JobTitle,
				   YearsInPosition,
				   MedicalClearanceStatus,
				   IsUnitCommander
			  FROM [persons].MatchingPersonsView
			 WHERE  UPPER(NationalID) = UPPER(@NationalID)
		 END
	 ELSE
		BEGIN
			SELECT PersonID,  
				   FirstMiddleNames,
				   LastNames,
				   DOB,
				   POBCityID,
				   Gender,
				   NationalID,
				   IsUSCitizen,
				   ResidenceLocationID,
				   ContactEmail,
				   ContactPhone,
				   HighestEducationID,
				   EnglishLanguageProficiencyID,
				   PassportNumber,
				   PassportExpirationDate,
				   PassportIssuingCountryID,
				   MatchCompletely = CASE WHEN UPPER(NationalID) = UPPER(@NationalID) THEN 1
										  ELSE 
											CASE WHEN UPPER(FirstMiddleNames) = UPPER(@FirstMiddleNames)  
												 AND UPPER(LastNames) = UPPER(@LastNames) AND CAST (DOB AS DATE) = CAST(@DOB AS DATE) AND POBCityID = @POBCityID AND Gender = @Gender
											THEN 0 ELSE 0 
											END 
										 END,
				  POBCityName,
				  POBStateName,
				  POBCountryName,
				  PersonLanguagesJSON,
				   UnitID,
				   RankID,
				   UnitMainAgencyID,
				   IsLeahyVettingReq,
				   IsVettingReq,
				   IsValidated,
				   HostNationPOCEmail,
				   HostNationPOCName,
				   PoliceMilSecID,
				   JobTitle,
				   YearsInPosition,
				   MedicalClearanceStatus,
				   IsUnitCommander
			  FROM [persons].MatchingPersonsView
			 WHERE (UPPER(FirstMiddleNames) = UPPER(@FirstMiddleNames)  AND 
						UPPER(LastNames) = UPPER(@LastNames) AND 
						CAST (DOB AS DATE) = CAST(@DOB AS DATE) AND 
						POBCityID = @POBCityID AND Gender = @Gender )
				   OR ((FirstMiddleNames) = UPPER(@FirstMiddleNames) AND 
						UPPER(LastNames) = UPPER(@LastNames)  AND 
						CAST(DOB AS DATE) = CAST(@DOB AS DATE) AND Gender = @Gender)
				   OR ((FirstMiddleNames) = UPPER(@FirstMiddleNames)  AND 
						POBCityID = @POBCityID AND CAST(DOB AS DATE) = CAST(@DOB AS DATE) AND Gender = @Gender)
				   OR (UPPER(LastNames) = UPPER(@LastNames) AND CAST(DOB AS DATE) = CAST(@DOB AS DATE) AND
						Gender = @Gender AND
						POBCityID = @POBCityID)
				   OR UPPER(NationalID) = UPPER(@NationalID)
			ORDER BY CASE WHEN UPPER(NationalID) = UPPER(@NationalID) THEN 2
										  ELSE 
											CASE WHEN UPPER(FirstMiddleNames) = UPPER(@FirstMiddleNames)  
												 AND UPPER(LastNames) = UPPER(@LastNames) AND CAST (DOB AS DATE) = CAST(@DOB AS DATE) AND POBCityID = @POBCityID AND Gender = @Gender
											THEN 1 ELSE 0 
											END 
										 END DESC
		END
END
