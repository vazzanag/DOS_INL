
namespace INL.TrainingService.Models
{
    public interface ITrainingEventTypesAtBusinessUnit_Item
    {
        int TrainingEventTypeID { get; set; }
        string TrainingEventTypeName { get; set; }
        long BusinessUnitID { get; set; }
        string Acronym { get; set; }
        string BusinessUnitName { get; set; }
        bool BusinessUnitActive { get; set; }
        bool TrainingEventTypeBusinessUnitActive { get; set; }
    }
}
