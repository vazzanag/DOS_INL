
namespace INL.TrainingService.Models
{
    public class InterAgencyAgreementsAtBusinessUnit_Item : IInterAgencyAgreementsAtBusinessUnit_Item
    {
        public int InterAgencyAgreementID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public long BusinessUnitID { get; set; }
        public string Acronym { get; set; }
        public string BusinessUnitName { get; set; }
        public bool BusinessUnitActive { get; set; }
        public bool InterAgencyAgreementBusinessUnitActive { get; set; }
    }
}
