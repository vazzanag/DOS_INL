namespace INL.TrainingService.Data
{
    public class ITrainingRemovalCausesEntity
    {
        int RemovalCauseID { get; set; }
        int RemovalReasonID { get; set; }
        string Description { get; set; }
        bool IsActive { get; set; }
    }
}