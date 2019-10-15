namespace INL.TrainingService.Models
{
    public class SaveTrainingEventGroup_Param : ISaveTrainingEventGroup_Param
    {
        public long? TrainingEventGroupID { get; set; }
        public long TrainingEventID { get; set; }
        public string GroupName { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
