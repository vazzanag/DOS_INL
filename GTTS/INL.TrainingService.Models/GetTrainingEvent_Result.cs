
namespace INL.TrainingService.Models
{
    public class GetTrainingEvent_Result : IGetTrainingEvent_Result
    {
        public IGetTrainingEvent_Item TrainingEvent { get; set; }
    }
}
