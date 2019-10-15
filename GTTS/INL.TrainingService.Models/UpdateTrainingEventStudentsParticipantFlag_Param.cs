namespace INL.TrainingService.Models
{
    public class UpdateTrainingEventStudentsParticipantFlag_Param : IUpdateTrainingEventStudentsParticipantFlag_Param
    {
        public long TrainingEventID { get; set; }
        public long[] PersonIDs { get; set; }
        public bool IsParticipant { get; set; }
    }
}
