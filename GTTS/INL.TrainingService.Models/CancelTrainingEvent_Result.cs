namespace INL.TrainingService.Models
{
    public class CancelTrainingEvent_Result : ICancelTrainingEvent_Result
    {
        public IStatusLog_Item Log { get; set; }
    }
}
