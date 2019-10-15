using INL.Services.Models;
using System;
using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public class SavePerson_Result : BaseResult, ISavePerson_Result
    {
        public long? PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public long? UnitID { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public string ResidenceStreetAddress { get; set; }
        public int? ResidenceCityID { get; set; }
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
        public string LawPoliceMilitaryID { get; set; }
        public int? Rank { get; set; }
        public int? YearsInCurrentPosition { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? DentalClearanceStatus { get; set; }
        public DateTime? DentalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public List<PersonLanguage_Item> Languages { get; set; }
    }
}
