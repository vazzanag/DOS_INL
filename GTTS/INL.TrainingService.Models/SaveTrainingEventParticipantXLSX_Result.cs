using System;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipantXLSX_Result : BaseResult, ISaveTrainingEventParticipantXLSX_Result
    {
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
        public int? ModifiedByAppUserID { get; set; }
    }
}
