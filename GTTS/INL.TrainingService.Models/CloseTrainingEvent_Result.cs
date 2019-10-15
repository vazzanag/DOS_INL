
namespace INL.TrainingService.Models
{
    public class CloseTrainingEvent_Result : ICloseTrainingEvent_Result
    {
        public IStatusLog_Item Log { get; set; }
    }
}
