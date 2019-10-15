
namespace INL.TrainingService.Models
{
    public interface IStatusLogInsert_Param
    {
        long? TrainingEventID { get; set; }
        string ReasonStatusChanged { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
