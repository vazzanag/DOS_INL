using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetPersonsWithUnitLibraryInfo_Item : IGetPersonsWithUnitLibraryInfo_Item
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
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public long? UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string WorkEmailAddress { get; set; }
        public int? RankID { get; set; }
        public string RankName { get; set; }
        public bool? IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public bool? HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public bool? IsVettingReq { get; set; }
        public bool? IsLeahyVettingReq { get; set; }
        public bool? IsArmedForces { get; set; }
        public bool? IsLawEnforcement { get; set; }
        public bool? IsSecurityIntelligence { get; set; }
        public bool? IsValidated { get; set; }
        public bool? IsInVettingProcess { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string PersonLanguagesJSON { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public int? CountryID { get; set; }
    }
}
