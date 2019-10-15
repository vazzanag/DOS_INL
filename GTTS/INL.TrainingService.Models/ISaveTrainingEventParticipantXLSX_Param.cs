using System;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipantXLSX_Param : IBaseParam
    {
        long ParticipantXLSXID { get; set; }
        string ParticipantStatus { get; set; }
        string FirstMiddleName { get; set; }
        string LastName { get; set; }
        string NationalID { get; set; }
        char? Gender { get; set; }
        string IsUSCitizen { get; set; }
        DateTime? DOB { get; set; }
        string POBCity { get; set; }
        string POBState { get; set; }
        string POBCountry { get; set; }
        string ResidenceCity { get; set; }
        string ResidenceState { get; set; }
        string ResidenceCountry { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        string UnitGenID { get; set; }
        string VettingType { get; set; }
        string JobTitle { get; set; }
        int? YearsInPosition { get; set; }
        string IsUnitCommander { get; set; }
        string PoliceMilSecID { get; set; }
        string POCName { get; set; }
        string POCEmail { get; set; }
        string DepartureCity { get; set; }
        int? DepartureCountryID { get; set; }
        int? DepartureStateID { get; set; }
        int? DepartureCityID { get; set; }
        string PassportNumber { get; set; }
        DateTime? PassportExpirationDate { get; set; }
        string Comments { get; set; }
        string HasLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        string PassedExternalVetting { get; set; }
        string ExternalVettingDescription { get; set; }
        DateTime? ExternalVettingDate { get; set; }
        string HighestEducation { get; set; }
        string EnglishLanguageProficiency { get; set; }
        string Rank { get; set; }
        long? PersonID { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
