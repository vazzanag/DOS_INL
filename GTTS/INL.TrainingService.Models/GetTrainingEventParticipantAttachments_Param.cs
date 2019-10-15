
namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipantAttachments_Param: IGetTrainingEventParticipantAttachments_Param
    {
        public long TrainingEventID { get; set; }
        public long PersonID { get; set; }
        public string ParticipantType { get; set; }
    }
}
