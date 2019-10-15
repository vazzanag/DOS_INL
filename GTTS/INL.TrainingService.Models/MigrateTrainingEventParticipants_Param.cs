namespace INL.TrainingService.Models
{
    public class MigrateTrainingEventParticipants_Param
    {
        public long TrainingEventID { get; set; }
        public long[] PersonIDs { get; set; }
        public bool ToInstructor { get; set; }
        public bool IsParticipant { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
