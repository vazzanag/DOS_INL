namespace INL.TrainingService.Data
{
    public class ITrainingRemovalReasonsEntity
    {
        int RemovalReasonID { get; set; }
        string Description { get; set; }
        bool IsActive { get; set; }
        byte SortControl { get; set; }
    }
}