using System;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipant_Param
    {
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }
        string ParticipantType { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char? Gender { get; set; }
        int? UnitID { get; set; }
        bool? IsUSCitizen { get; set; }
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
        string LawPoliceMilitaryID { get; set; }
        int? JobTitleID { get; set; }
        int? RankID { get; set; }
        int? YearsInCurrentPosition { get; set; }
        int? TrainingEventGroupID { get; set; }
        bool? IsVIP { get; set; }
        bool? IsParticipant { get; set; }
        bool? IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VettingStatusID { get; set; }
        int? VisaStatusID { get; set; }
        bool? HasLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
		bool? OtherVetting { get; set; }
		bool PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool? RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        int? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
