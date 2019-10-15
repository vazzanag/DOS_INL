using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class DeleteTrainingEventParticipant_Param : BaseParam, IDeleteTrainingEventParticipant_Param
    {
        public DeleteTrainingEventParticipant_Param() : base() { }

        public long TrainingEventID { get; set; }
        public long ParticipantID { get; set; }
        public string ParticipantType { get; set; }
    }
}

