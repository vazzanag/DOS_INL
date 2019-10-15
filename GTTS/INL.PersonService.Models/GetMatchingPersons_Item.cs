using System;
using System.Collections.Generic;
using System.Text;

namespace INL.PersonService.Models
{
    public class GetMatchingPersons_Item : IGetMatchingPersons_Item
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
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
        public char? Gender { get; set; }
        public string NationalID { get; set; }
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
}
