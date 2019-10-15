using System;
using System.Collections.Generic;
using System.Text;
using INL.PersonService.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipant_Result
    {
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char? Gender { get; set; }
        int? UnitID { get; set; }
        bool? IsUSCitizen { get; set; }
        string NationalID { get; set; }
        int? ResidenceLocationID { get; set; }
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
        string PoliceMilSecID { get; set; }
        string JobTitle { get; set; }
        int? RankID { get; set; }
        int? YearsInPosition { get; set; }
        int? TrainingEventGroupID { get; set; }
        bool? IsVIP { get; set; }
        bool? IsParticipant { get; set; }
        bool? IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VettingStatusID { get; set; }
        int? VisaStatusID { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool? RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        string RemovalReason { get; set; }
        int? RemovalCauseID { get; set; }
        string RemovalCause { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }
        long? PersonsUnitLibraryInfoID { get; set; }

        List<IPersonLanguage_Item> Languages { get; set; }
    }
}
