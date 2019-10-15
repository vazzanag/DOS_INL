using System;
using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public class SavePerson_Param : ISavePerson_Param
    {
        public long? PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public long? UnitID { get; set; }
        public long? PersonsUnitLibraryInfoID { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public int? ResidenceCityID { get; set; }
        public string ResidenceStreetAddress { get; set; }
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
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public string JobTitle { get; set; }
        public int? RankID { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? IsUnitCommander { get; set; }
        public bool? HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public bool? IsVettingReq { get; set; }
        public bool? IsLeahyVettingReq { get; set; }
        public bool? IsArmedForces { get; set; }
        public bool? IsLawEnforcement { get; set; }
        public bool? IsSecurityIntelligence { get; set; }
        public bool? IsValidated { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? DentalClearanceStatus { get; set; }
        public DateTime? DentalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public int? ModifiedByAppUserID { get; set; }

        public List<IPersonLanguage_Item> Languages { get; set; }
        
        
        
    }
}
