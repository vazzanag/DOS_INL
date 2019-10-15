using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public interface IGetMatchingPersons_Item
    {
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        int? POBCityID { get; set; }
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
        char? Gender { get; set; }
        string NationalID { get; set; }
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
}
