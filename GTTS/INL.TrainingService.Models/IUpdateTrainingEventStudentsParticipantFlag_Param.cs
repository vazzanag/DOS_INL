namespace INL.TrainingService.Models
{
    public interface IUpdateTrainingEventStudentsParticipantFlag_Param
    {
        long TrainingEventID { get; set; }
        long[] PersonIDs { get; set; }
        bool IsParticipant { get; set; }
    }
}
