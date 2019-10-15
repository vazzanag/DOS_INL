
namespace INL.TrainingService.Models
{
    public interface IProjectCodesAtBusinessUnit_Item
    {
        int ProjectCodeID { get; set; }
        string Code { get; set; }
        string Description { get; set; }
        long BusinessUnitID { get; set; }
        string Acronym { get; set; }
        string BusinessUnitName { get; set; }
        bool BusinessUnitActive { get; set; }
        bool ProjectCodeBusinessUnitActive { get; set; }
    }
}
