 
  




using System;


namespace INL.PersonService.Data
{
  
	public interface IPersonsEntity
	{
		long PersonID { get; set; }
		string FirstMiddleNames { get; set; }
		string LastNames { get; set; }
		char Gender { get; set; }
		bool IsUSCitizen { get; set; }
		string NationalID { get; set; }
		long? ResidenceLocationID { get; set; }
		string ContactEmail { get; set; }
		string ContactPhone { get; set; }
		DateTime? DOB { get; set; }
		int? POBCityID { get; set; }
		string FatherName { get; set; }
		string MotherName { get; set; }
		int? HighestEducationID { get; set; }
		decimal? FamilyIncome { get; set; }
		int? EnglishLanguageProficiencyID { get; set; }
		string PassportNumber { get; set; }
		DateTime? PassportExpirationDate { get; set; }
		int? PassportIssuingCountryID { get; set; }
		bool? MedicalClearanceStatus { get; set; }
		DateTime? MedicalClearanceDate { get; set; }
		bool? DentalClearanceStatus { get; set; }
		DateTime? DentalClearanceDate { get; set; }
		bool? PsychologicalClearanceStatus { get; set; }
		DateTime? PsychologicalClearanceDate { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class PersonsEntity : IPersonsEntity
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public long? ResidenceLocationID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public int? HighestEducationID { get; set; }
        public decimal? FamilyIncome { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public int? PassportIssuingCountryID { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? DentalClearanceStatus { get; set; }
        public DateTime? DentalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      
	public interface IPersonsUnitLibraryInfoEntity
	{
		long PersonsUnitLibraryInfoID { get; set; }
		long PersonID { get; set; }
		long UnitID { get; set; }
		string JobTitle { get; set; }
		int? YearsInPosition { get; set; }
		string WorkEmailAddress { get; set; }
		int? RankID { get; set; }
		bool? IsUnitCommander { get; set; }
		string PoliceMilSecID { get; set; }
		string HostNationPOCName { get; set; }
		string HostNationPOCEmail { get; set; }
		bool IsVettingReq { get; set; }
		bool IsLeahyVettingReq { get; set; }
		bool IsArmedForces { get; set; }
		bool IsLawEnforcement { get; set; }
		bool IsSecurityIntelligence { get; set; }
		bool IsValidated { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class PersonsUnitLibraryInfoEntity : IPersonsUnitLibraryInfoEntity
    {
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public int? RankID { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
        
    }
      


	public interface IMatchingPersonsViewEntity
	{
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    int? POBCityID { get; set; }
	    char Gender { get; set; }
	    string NationalID { get; set; }
	    bool IsUSCitizen { get; set; }
	    long? ResidenceLocationID { get; set; }
	    string ContactEmail { get; set; }
	    string ContactPhone { get; set; }
	    int? HighestEducationID { get; set; }
	    int? EnglishLanguageProficiencyID { get; set; }
	    string PassportNumber { get; set; }
	    DateTime? PassportExpirationDate { get; set; }
	    int? PassportIssuingCountryID { get; set; }
	    int MatchCompletely { get; set; }
	    string POBCityName { get; set; }
	    string POBStateName { get; set; }
	    string POBCountryName { get; set; }
	    string PersonLanguagesJSON { get; set; }
	    long UnitID { get; set; }
	    int? RankID { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    bool IsLeahyVettingReq { get; set; }
	    bool IsVettingReq { get; set; }
	    bool IsValidated { get; set; }
	    string HostNationPOCEmail { get; set; }
	    string HostNationPOCName { get; set; }
	    string PoliceMilSecID { get; set; }
	    string JobTitle { get; set; }
	    int? YearsInPosition { get; set; }
	    bool? MedicalClearanceStatus { get; set; }
	    bool? IsUnitCommander { get; set; }

	}

    public class MatchingPersonsViewEntity : IMatchingPersonsViewEntity
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
        public char Gender { get; set; }
        public string NationalID { get; set; }
        public bool IsUSCitizen { get; set; }
        public long? ResidenceLocationID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public int? HighestEducationID { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public int? PassportIssuingCountryID { get; set; }
        public int MatchCompletely { get; set; }
        public string POBCityName { get; set; }
        public string POBStateName { get; set; }
        public string POBCountryName { get; set; }
        public string PersonLanguagesJSON { get; set; }
        public long UnitID { get; set; }
        public int? RankID { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsValidated { get; set; }
        public string HostNationPOCEmail { get; set; }
        public string HostNationPOCName { get; set; }
        public string PoliceMilSecID { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public bool? IsUnitCommander { get; set; }
        
    }
      
	public interface IParticipantsViewEntity
	{
	    long PersonID { get; set; }
	    int CountryID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    char Gender { get; set; }
	    string AgencyName { get; set; }
	    string UnitName { get; set; }
	    string RankName { get; set; }
	    string JobTitle { get; set; }
	    string LastVettingTypeCode { get; set; }
	    string LastVettingStatusCode { get; set; }
	    DateTime? LastVettingStatusDate { get; set; }
	    string ParticipantType { get; set; }
	    string Distinction { get; set; }
	    DateTime? TrainingDate { get; set; }
	    DateTime? DOB { get; set; }
	    string UnitNameEnglish { get; set; }
	    string UnitAcronym { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string NationalID { get; set; }
	    DateTime? VettingValidEndDate { get; set; }

	}

    public class ParticipantsViewEntity : IParticipantsViewEntity
    {
        public long PersonID { get; set; }
        public int CountryID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public string AgencyName { get; set; }
        public string UnitName { get; set; }
        public string RankName { get; set; }
        public string JobTitle { get; set; }
        public string LastVettingTypeCode { get; set; }
        public string LastVettingStatusCode { get; set; }
        public DateTime? LastVettingStatusDate { get; set; }
        public string ParticipantType { get; set; }
        public string Distinction { get; set; }
        public DateTime? TrainingDate { get; set; }
        public DateTime? DOB { get; set; }
        public string UnitNameEnglish { get; set; }
        public string UnitAcronym { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string NationalID { get; set; }
        public DateTime? VettingValidEndDate { get; set; }
        
    }
      
	public interface IPersonAttachmentsViewEntity
	{
	    long PersonID { get; set; }
	    int FileID { get; set; }
	    string FileName { get; set; }
	    string FileLocation { get; set; }
	    int PersonAttachmentTypeID { get; set; }
	    string PersonAttachmentType { get; set; }
	    string Description { get; set; }
	    bool? IsDeleted { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string FullName { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class PersonAttachmentsViewEntity : IPersonAttachmentsViewEntity
    {
        public long PersonID { get; set; }
        public int FileID { get; set; }
        public string FileName { get; set; }
        public string FileLocation { get; set; }
        public int PersonAttachmentTypeID { get; set; }
        public string PersonAttachmentType { get; set; }
        public string Description { get; set; }
        public bool? IsDeleted { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string FullName { get; set; }
        public DateTime ModifiedDate { get; set; }
        
    }
      
	public interface IPersonLanguagesViewEntity
	{
	    long PersonID { get; set; }
	    int LanguageID { get; set; }
	    int? LanguageProficiencyID { get; set; }
	    string LanguageCode { get; set; }
	    string LanguageDescription { get; set; }
	    string LanguageProficiencyCode { get; set; }
	    string LanguageProficiencyDescription { get; set; }
	    int ModifiedByAppUserID { get; set; }

	}

    public class PersonLanguagesViewEntity : IPersonLanguagesViewEntity
    {
        public long PersonID { get; set; }
        public int LanguageID { get; set; }
        public int? LanguageProficiencyID { get; set; }
        public string LanguageCode { get; set; }
        public string LanguageDescription { get; set; }
        public string LanguageProficiencyCode { get; set; }
        public string LanguageProficiencyDescription { get; set; }
        public int ModifiedByAppUserID { get; set; }
        
    }
      
	public interface IPersonsUnitLibraryInfoViewEntity
	{
	    long PersonsUnitLibraryInfoID { get; set; }
	    long PersonID { get; set; }
	    long UnitID { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    int UnitTypeID { get; set; }
	    string UnitType { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string JobTitle { get; set; }
	    int? YearsInPosition { get; set; }
	    string WorkEmailAddress { get; set; }
	    string HostNationPOCName { get; set; }
	    string HostNationPOCEmail { get; set; }
	    int? RankID { get; set; }
	    string RankName { get; set; }
	    bool? IsUnitCommander { get; set; }
	    string PoliceMilSecID { get; set; }
	    bool IsVettingReq { get; set; }
	    bool IsLeahyVettingReq { get; set; }
	    bool IsArmedForces { get; set; }
	    bool IsLawEnforcement { get; set; }
	    bool IsSecurityIntelligence { get; set; }
	    bool IsValidated { get; set; }
	    int CountryID { get; set; }
	    bool IsActive { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string ModifiedByAppUser { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string UnitAliasJson { get; set; }
	    string CommanderFirstName { get; set; }
	    string CommanderLastName { get; set; }
	    string CommanderEmail { get; set; }
	    string UnitGenID { get; set; }

	}

    public class PersonsUnitLibraryInfoViewEntity : IPersonsUnitLibraryInfoViewEntity
    {
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public int UnitTypeID { get; set; }
        public string UnitType { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public int CountryID { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string ModifiedByAppUser { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string UnitAliasJson { get; set; }
        public string CommanderFirstName { get; set; }
        public string CommanderLastName { get; set; }
        public string CommanderEmail { get; set; }
        public string UnitGenID { get; set; }
        
    }
      
	public interface IPersonsUnitViewEntity
	{
	    long PersonsUnitLibraryInfoID { get; set; }
	    long PersonID { get; set; }
	    long UnitID { get; set; }
	    string JobTitle { get; set; }
	    int? RankID { get; set; }
	    string RankName { get; set; }
	    int? YearsInPosition { get; set; }
	    bool? IsUnitCommander { get; set; }
	    string BadgeNumber { get; set; }
	    string HostNationPOCEmail { get; set; }
	    string HostNationPOCName { get; set; }
	    string WorkEmailAddress { get; set; }
	    bool IsVettingReq { get; set; }
	    bool IsLeahyVettingReq { get; set; }
	    bool IsArmedForces { get; set; }
	    bool IsLawEnforcement { get; set; }
	    bool IsSecurityIntelligence { get; set; }
	    bool IsValidated { get; set; }
	    bool IsActive { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string UnitGenID { get; set; }
	    int UnitTypeID { get; set; }
	    string UnitType { get; set; }
	    string CommanderFirstName { get; set; }
	    string CommanderLastName { get; set; }
	    string CommanderEmail { get; set; }
	    string UnitBreakdownEnglish { get; set; }
	    string UnitBreakDownLocalLang { get; set; }

	}

    public class PersonsUnitViewEntity : IPersonsUnitViewEntity
    {
        public long PersonsUnitLibraryInfoID { get; set; }
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string JobTitle { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string BadgeNumber { get; set; }
        public string HostNationPOCEmail { get; set; }
        public string HostNationPOCName { get; set; }
        public string WorkEmailAddress { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public bool IsActive { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string UnitGenID { get; set; }
        public int UnitTypeID { get; set; }
        public string UnitType { get; set; }
        public string CommanderFirstName { get; set; }
        public string CommanderLastName { get; set; }
        public string CommanderEmail { get; set; }
        public string UnitBreakdownEnglish { get; set; }
        public string UnitBreakDownLocalLang { get; set; }
        
    }
      
	public interface IPersonsViewEntity
	{
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    char Gender { get; set; }
	    bool IsUSCitizen { get; set; }
	    string NationalID { get; set; }
	    long? ResidenceLocationID { get; set; }
	    string ResidenceStreetAddress { get; set; }
	    int? ResidenceCityID { get; set; }
	    int? ResidenceStateID { get; set; }
	    int? ResidenceCountryID { get; set; }
	    int? POBCityID { get; set; }
	    string POBCityName { get; set; }
	    int? POBStateID { get; set; }
	    string POBStateName { get; set; }
	    int? POBCountryID { get; set; }
	    string POBCountryName { get; set; }
	    string ContactEmail { get; set; }
	    string ContactPhone { get; set; }
	    DateTime? DOB { get; set; }
	    string FatherName { get; set; }
	    string MotherName { get; set; }
	    int? HighestEducationID { get; set; }
	    decimal? FamilyIncome { get; set; }
	    int? EnglishLanguageProficiencyID { get; set; }
	    string PassportNumber { get; set; }
	    DateTime? PassportExpirationDate { get; set; }
	    int? PassportIssuingCountryID { get; set; }
	    bool? MedicalClearanceStatus { get; set; }
	    DateTime? MedicalClearanceDate { get; set; }
	    bool? PsychologicalClearanceStatus { get; set; }
	    DateTime? PsychologicalClearanceDate { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string PlaceOfBirth { get; set; }
	    string PlaceOfResidence { get; set; }
	    string EducationLevel { get; set; }
	    string PersonLanguagesJSON { get; set; }

	}

    public class PersonsViewEntity : IPersonsViewEntity
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public long? ResidenceLocationID { get; set; }
        public string ResidenceStreetAddress { get; set; }
        public int? ResidenceCityID { get; set; }
        public int? ResidenceStateID { get; set; }
        public int? ResidenceCountryID { get; set; }
        public int? POBCityID { get; set; }
        public string POBCityName { get; set; }
        public int? POBStateID { get; set; }
        public string POBStateName { get; set; }
        public int? POBCountryID { get; set; }
        public string POBCountryName { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public int? HighestEducationID { get; set; }
        public decimal? FamilyIncome { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public int? PassportIssuingCountryID { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string PlaceOfBirth { get; set; }
        public string PlaceOfResidence { get; set; }
        public string EducationLevel { get; set; }
        public string PersonLanguagesJSON { get; set; }
        
    }
      
	public interface IPersonsWithUnitLibraryInfoViewEntity
	{
	    long PersonID { get; set; }
	    long? PersonsUnitLibraryInfoID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    char Gender { get; set; }
	    bool IsUSCitizen { get; set; }
	    string NationalID { get; set; }
	    long? ResidenceLocationID { get; set; }
	    string ResidenceStreetAddress { get; set; }
	    int? ResidenceCityID { get; set; }
	    int? ResidenceStateID { get; set; }
	    int? ResidenceCountryID { get; set; }
	    int? POBCityID { get; set; }
	    int? POBStateID { get; set; }
	    int? POBCountryID { get; set; }
	    string ContactEmail { get; set; }
	    string ContactPhone { get; set; }
	    DateTime? DOB { get; set; }
	    string FatherName { get; set; }
	    string MotherName { get; set; }
	    int? HighestEducationID { get; set; }
	    decimal? FamilyIncome { get; set; }
	    int? EnglishLanguageProficiencyID { get; set; }
	    string PassportNumber { get; set; }
	    DateTime? PassportExpirationDate { get; set; }
	    int? PassportIssuingCountryID { get; set; }
	    string HostNationPOCName { get; set; }
	    string HostNationPOCEmail { get; set; }
	    bool? MedicalClearanceStatus { get; set; }
	    DateTime? MedicalClearanceDate { get; set; }
	    bool? PsychologicalClearanceStatus { get; set; }
	    DateTime? PsychologicalClearanceDate { get; set; }
	    long? UnitID { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string JobTitle { get; set; }
	    int? YearsInPosition { get; set; }
	    string WorkEmailAddress { get; set; }
	    int? RankID { get; set; }
	    string RankName { get; set; }
	    bool? IsUnitCommander { get; set; }
	    string PoliceMilSecID { get; set; }
	    int? CountryID { get; set; }
	    bool? IsVettingReq { get; set; }
	    bool? IsLeahyVettingReq { get; set; }
	    bool? IsArmedForces { get; set; }
	    bool? IsLawEnforcement { get; set; }
	    bool? IsSecurityIntelligence { get; set; }
	    bool? IsValidated { get; set; }
	    bool? IsInVettingProcess { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string PersonLanguagesJSON { get; set; }

	}

    public class PersonsWithUnitLibraryInfoViewEntity : IPersonsWithUnitLibraryInfoViewEntity
    {
        public long PersonID { get; set; }
        public long? PersonsUnitLibraryInfoID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public long? ResidenceLocationID { get; set; }
        public string ResidenceStreetAddress { get; set; }
        public int? ResidenceCityID { get; set; }
        public int? ResidenceStateID { get; set; }
        public int? ResidenceCountryID { get; set; }
        public int? POBCityID { get; set; }
        public int? POBStateID { get; set; }
        public int? POBCountryID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public int? HighestEducationID { get; set; }
        public decimal? FamilyIncome { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public int? PassportIssuingCountryID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public long? UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public int? CountryID { get; set; }
        public bool? IsVettingReq { get; set; }
        public bool? IsLeahyVettingReq { get; set; }
        public bool? IsArmedForces { get; set; }
        public bool? IsLawEnforcement { get; set; }
        public bool? IsSecurityIntelligence { get; set; }
        public bool? IsValidated { get; set; }
        public bool? IsInVettingProcess { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string PersonLanguagesJSON { get; set; }
        
    }
      
	public interface IRanksViewEntity
	{
	    int RankID { get; set; }
	    string RankName { get; set; }
	    int CountryID { get; set; }

	}

    public class RanksViewEntity : IRanksViewEntity
    {
        public int RankID { get; set; }
        public string RankName { get; set; }
        public int CountryID { get; set; }
        
    }
      


	public interface IGetAllParticipantsEntity
    {
        int? CountryID { get; set; }
        string ParticipantType { get; set; }

    }

    public class GetAllParticipantsEntity : IGetAllParticipantsEntity
    {
		public int? CountryID { get; set; }
		public string ParticipantType { get; set; }

    }
      
	public interface IGetMatchingPersonsEntity
    {
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        int? POBCityID { get; set; }
        char? Gender { get; set; }
        string NationalID { get; set; }
        bool? ExactMatch { get; set; }

    }

    public class GetMatchingPersonsEntity : IGetMatchingPersonsEntity
    {
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public int? POBCityID { get; set; }
		public char? Gender { get; set; }
		public string NationalID { get; set; }
		public bool? ExactMatch { get; set; }

    }
      
	public interface IGetPersonEntity
    {
        long? PersonID { get; set; }

    }

    public class GetPersonEntity : IGetPersonEntity
    {
		public long? PersonID { get; set; }

    }
      
	public interface IGetPersonAttachmentsEntity
    {
        long? PersonID { get; set; }

    }

    public class GetPersonAttachmentsEntity : IGetPersonAttachmentsEntity
    {
		public long? PersonID { get; set; }

    }
      
	public interface IGetPersonsUnitEntity
    {
        long? PersonID { get; set; }

    }

    public class GetPersonsUnitEntity : IGetPersonsUnitEntity
    {
		public long? PersonID { get; set; }

    }
      
	public interface IGetPersonsUnitLibraryInfoEntity
    {
        long? PersonsUnitLibraryInfoID { get; set; }
        long? PersonID { get; set; }
        long? UnitID { get; set; }

    }

    public class GetPersonsUnitLibraryInfoEntity : IGetPersonsUnitLibraryInfoEntity
    {
		public long? PersonsUnitLibraryInfoID { get; set; }
		public long? PersonID { get; set; }
		public long? UnitID { get; set; }

    }
      
	public interface IGetPersonsWithUnitLibraryInfoByCountryIDEntity
    {
        int? CountryID { get; set; }

    }

    public class GetPersonsWithUnitLibraryInfoByCountryIDEntity : IGetPersonsWithUnitLibraryInfoByCountryIDEntity
    {
		public int? CountryID { get; set; }

    }
      
	public interface IGetRanksByCountryIDEntity
    {
        int? CountryID { get; set; }

    }

    public class GetRanksByCountryIDEntity : IGetRanksByCountryIDEntity
    {
		public int? CountryID { get; set; }

    }
      
	public interface ISavePersonEntity
    {
        long? PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char? Gender { get; set; }
        bool? IsUSCitizen { get; set; }
        string NationalID { get; set; }
        long? ResidenceLocationID { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        DateTime? DOB { get; set; }
        int? POBCityID { get; set; }
        string FatherName { get; set; }
        string MotherName { get; set; }
        int? HighestEducationID { get; set; }
        decimal? FamilyIncome { get; set; }
        int? EnglishLanguageProficiencyID { get; set; }
        string PassportNumber { get; set; }
        DateTime? PassportExpirationDate { get; set; }
        int? PassportIssuingCountryID { get; set; }
        bool? MedicalClearanceStatus { get; set; }
        DateTime? MedicalClearanceDate { get; set; }
        bool? DentalClearanceStatus { get; set; }
        DateTime? DentalClearanceDate { get; set; }
        bool? PsychologicalClearanceStatus { get; set; }
        DateTime? PsychologicalClearanceDate { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string LanguagesJSON { get; set; }

    }

    public class SavePersonEntity : ISavePersonEntity
    {
		public long? PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public char? Gender { get; set; }
		public bool? IsUSCitizen { get; set; }
		public string NationalID { get; set; }
		public long? ResidenceLocationID { get; set; }
		public string ContactEmail { get; set; }
		public string ContactPhone { get; set; }
		public DateTime? DOB { get; set; }
		public int? POBCityID { get; set; }
		public string FatherName { get; set; }
		public string MotherName { get; set; }
		public int? HighestEducationID { get; set; }
		public decimal? FamilyIncome { get; set; }
		public int? EnglishLanguageProficiencyID { get; set; }
		public string PassportNumber { get; set; }
		public DateTime? PassportExpirationDate { get; set; }
		public int? PassportIssuingCountryID { get; set; }
		public bool? MedicalClearanceStatus { get; set; }
		public DateTime? MedicalClearanceDate { get; set; }
		public bool? DentalClearanceStatus { get; set; }
		public DateTime? DentalClearanceDate { get; set; }
		public bool? PsychologicalClearanceStatus { get; set; }
		public DateTime? PsychologicalClearanceDate { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string LanguagesJSON { get; set; }

    }
      
	public interface ISavePersonAttachmentEntity
    {
        long? PersonID { get; set; }
        long? FileID { get; set; }
        int? FileVersion { get; set; }
        string PersonAttachmentType { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SavePersonAttachmentEntity : ISavePersonAttachmentEntity
    {
		public long? PersonID { get; set; }
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }
		public string PersonAttachmentType { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISavePersonsUnitLibraryInfoEntity
    {
        long? PersonsUnitLibraryInfoID { get; set; }
        long? PersonID { get; set; }
        long? UnitID { get; set; }
        string JobTitle { get; set; }
        int? YearsInPosition { get; set; }
        string WorkEmailAddress { get; set; }
        int? RankID { get; set; }
        bool? IsUnitCommander { get; set; }
        string PoliceMilSecID { get; set; }
        string HostNationPOCName { get; set; }
        string HostNationPOCEmail { get; set; }
        bool? IsVettingReq { get; set; }
        bool? IsLeahyVettingReq { get; set; }
        bool? IsArmedForces { get; set; }
        bool? IsLawEnforcement { get; set; }
        bool? IsSecurityIntelligence { get; set; }
        bool? IsValidated { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SavePersonsUnitLibraryInfoEntity : ISavePersonsUnitLibraryInfoEntity
    {
		public long? PersonsUnitLibraryInfoID { get; set; }
		public long? PersonID { get; set; }
		public long? UnitID { get; set; }
		public string JobTitle { get; set; }
		public int? YearsInPosition { get; set; }
		public string WorkEmailAddress { get; set; }
		public int? RankID { get; set; }
		public bool? IsUnitCommander { get; set; }
		public string PoliceMilSecID { get; set; }
		public string HostNationPOCName { get; set; }
		public string HostNationPOCEmail { get; set; }
		public bool? IsVettingReq { get; set; }
		public bool? IsLeahyVettingReq { get; set; }
		public bool? IsArmedForces { get; set; }
		public bool? IsLawEnforcement { get; set; }
		public bool? IsSecurityIntelligence { get; set; }
		public bool? IsValidated { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      





}




