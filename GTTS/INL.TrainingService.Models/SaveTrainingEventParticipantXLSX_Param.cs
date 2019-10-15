using System;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipantXLSX_Param : BaseParam, ISaveTrainingEventParticipantXLSX_Param
    {
        public SaveTrainingEventParticipantXLSX_Param() : base() { }
        public long ParticipantXLSXID { get; set; }
        public string ParticipantStatus { get; set; }
        public string FirstMiddleName { get; set; }
        public string LastName { get; set; }
        public string NationalID { get; set; }
        public char? Gender { get; set; }
        public string IsUSCitizen { get; set; }
        public DateTime? DOB { get; set; }
        public string POBCity { get; set; }
        public string POBState { get; set; }
        public string POBCountry { get; set; }
        public string ResidenceCity { get; set; }
        public string ResidenceState { get; set; }
        public string ResidenceCountry { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public string UnitGenID { get; set; }
        public string VettingType { get; set; }
        public string JobTitle { get; set; }
        public int? YearsInPosition { get; set; }
        public string IsUnitCommander { get; set; }
        public string PoliceMilSecID { get; set; }
        public string POCName { get; set; }
        public string POCEmail { get; set; }
        public string DepartureCity { get; set; }
        public int? DepartureCountryID { get; set; }
        public int? DepartureStateID { get; set; }
        public int? DepartureCityID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public string Comments { get; set; }
        public string HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public string PassedExternalVetting { get; set; }
        public string ExternalVettingDescription { get; set; }
        public DateTime? ExternalVettingDate { get; set; }
        public string HighestEducation { get; set; }
        public string EnglishLanguageProficiency { get; set; }
        public string Rank { get; set; }
        public long? PersonID { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
