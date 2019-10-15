using System;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventInstructor_Param : ISaveTrainingEventInstructor_Param
    {
        public long? PersonID { get; set; }
        public long? TrainingEventID { get; set; }
        public long? PersonsVettingID { get; set; }
        public string FirstMiddleNames { get; set; }
        
        
        
        public string LastNames { get; set; }
        public char? Gender { get; set; }
        public int? UnitID { get; set; }
        public bool? IsUSCitizen { get; set; }
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
        public string LawPoliceMilitaryID { get; set; }
        public int? JobTitleID { get; set; }
        public int? RankID { get; set; }
        public int? YearsInCurrentPosition { get; set; }
        public int? TrainingEventGroupID { get; set; }
        public bool? IsTraveling { get; set; }
        public int? DepartureCityID { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public int? VettingStatusID { get; set; }
        public int? VisaStatusID { get; set; }
        public int? PaperworkStatusID { get; set; }
        public int? TravelDocumentStatusID { get; set; }
        public bool? RemovedFromEvent { get; set; }
        public int? RemovalReasonID { get; set; }
        public int? RemovalCauseID { get; set; }
        public DateTime? DateCanceled { get; set; }
        public string Comments { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
