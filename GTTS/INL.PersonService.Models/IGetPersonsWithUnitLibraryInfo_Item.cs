using System;

namespace INL.PersonService.Models
{
    public interface IGetPersonsWithUnitLibraryInfo_Item
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
        bool? MedicalClearanceStatus { get; set; }
		DateTime? MedicalClearanceDate { get; set; }
		bool? PsychologicalClearanceStatus { get; set; }
		DateTime? PsychologicalClearanceDate { get; set; }
		Int64? UnitID { get; set; }
		string UnitName { get; set; }
		string UnitNameEnglish { get; set; }
		string JobTitle { get; set; }
		int? YearsInPosition { get; set; }
		string WorkEmailAddress { get; set; }
		int? RankID { get; set; }
		string RankName { get; set; }
		bool? IsUnitCommander { get; set; }
		string PoliceMilSecID { get; set; }
        string HostNationPOCName { get; set; }
        string HostNationPOCEmail { get; set; }
		bool? HasLocalGovTrust { get; set; }
		DateTime? LocalGovTrustCertDate { get; set; }
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
}
