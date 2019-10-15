
namespace INL.TrainingService.Models
{
    public class ProjectCodesAtBusinessUnit_Item : IProjectCodesAtBusinessUnit_Item
    {
        public int ProjectCodeID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public long BusinessUnitID { get; set; }
        public string Acronym { get; set; }
        public string BusinessUnitName { get; set; }
        public bool BusinessUnitActive { get; set; }
        public bool ProjectCodeBusinessUnitActive { get; set; }
    }
}
