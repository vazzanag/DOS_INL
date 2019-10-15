
namespace INL.TrainingService.Models
{
    public class CloseTrainingEvent_Param : ICloseTrainingEvent_Param
    {
        public long? TrainingEventID { get; set; }
        public string ReasonStatusChanged { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
