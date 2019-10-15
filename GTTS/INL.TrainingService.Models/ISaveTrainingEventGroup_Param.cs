namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventGroup_Param
    {
        long? TrainingEventGroupID { get; set; }
        long TrainingEventID { get; set; }
        string GroupName { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
