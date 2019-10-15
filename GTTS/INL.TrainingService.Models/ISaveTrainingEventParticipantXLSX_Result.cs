using System;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipantXLSX_Result : IBaseResult
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
        int? ModifiedByAppUserID { get; set; }
    }
}
