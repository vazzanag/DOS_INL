using INL.Services.Models;
using System;
using System.Collections.Generic;

namespace INL.PersonService.Models
{
    public interface ISavePerson_Result : IBaseResult
    {
        long? PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char Gender { get; set; }
        long? UnitID { get; set; }
        bool IsUSCitizen { get; set; }
        string NationalID { get; set; }
        string ResidenceStreetAddress { get; set; }
        int? ResidenceCityID { get; set; }
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
        string LawPoliceMilitaryID { get; set; }
        int? Rank { get; set; }
        int? YearsInCurrentPosition { get; set; }
        bool? MedicalClearanceStatus { get; set; }
        DateTime? MedicalClearanceDate { get; set; }
        bool? DentalClearanceStatus { get; set; }
        DateTime? DentalClearanceDate { get; set; }
        bool? PsychologicalClearanceStatus { get; set; }
        DateTime? PsychologicalClearanceDate { get; set; }
        int? ModifiedByAppUserID { get; set; }

        List<PersonLanguage_Item> Languages { get; set; }
    }
}
