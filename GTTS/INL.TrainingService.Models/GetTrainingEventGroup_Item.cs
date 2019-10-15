namespace INL.TrainingService.Models
{
    public class GetTrainingEventGroup_Item
    {
        public int Ordinal { get; set; }
        public long TrainingEventGroupID { get; set; }
        public long TrainingEventID { get; set; }
        public string TrainingEventName { get; set; }
        public string GroupName { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
