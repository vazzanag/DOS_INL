namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventGroup_Item
    {
        long TrainingEventGroupID { get; set; }
        long TrainingEventID { get; set; }
        string TrainingEventName { get; set; }
        string GroupName { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
