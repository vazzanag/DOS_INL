using System;
using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public interface ISavePerson_Param
    {
        long? PersonID { get; set; }
        long? PersonsUnitLibraryInfoID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char Gender { get; set; }
        long? UnitID { get; set; }
        bool IsUSCitizen { get; set; }
        string NationalID { get; set; }
        long? ResidenceLocationID { get; set; }
        int? ResidenceCityID { get; set; }
        string ResidenceStreetAddress { get; set; }
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
        string PoliceMilSecID { get; set; }
        string HostNationPOCName { get; set; }
        string HostNationPOCEmail { get; set; }
        string JobTitle { get; set; }
        int? RankID { get; set; }
        int? YearsInPosition { get; set; }
        bool? IsUnitCommander { get; set; }
        bool? MedicalClearanceStatus { get; set; }
        bool? HasLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        bool? IsVettingReq { get; set; }
        bool? IsLeahyVettingReq { get; set; }
        bool? IsArmedForces { get; set; }
        bool? IsLawEnforcement { get; set; }
        bool? IsSecurityIntelligence { get; set; }
        bool? IsValidated { get; set; }
        DateTime? MedicalClearanceDate { get; set; }
        bool? DentalClearanceStatus { get; set; }
        DateTime? DentalClearanceDate { get; set; }
        bool? PsychologicalClearanceStatus { get; set; }
        DateTime? PsychologicalClearanceDate { get; set; }
        int? ModifiedByAppUserID { get; set; }

        List<IPersonLanguage_Item> Languages { get; set; }
    }
}
