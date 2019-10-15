
namespace INL.TrainingService.Models
{
    public class TrainingEventTypesAtBusinessUnit_Item : ITrainingEventTypesAtBusinessUnit_Item
    {
        public int TrainingEventTypeID { get; set; }
        public string TrainingEventTypeName { get; set; }
        public long BusinessUnitID { get; set; }
        public string Acronym { get; set; }
        public string BusinessUnitName { get; set; }
        public bool BusinessUnitActive { get; set; }
        public bool TrainingEventTypeBusinessUnitActive { get; set; }
    }
}
