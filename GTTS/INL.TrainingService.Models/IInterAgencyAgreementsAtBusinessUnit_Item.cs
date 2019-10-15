
namespace INL.TrainingService.Models
{
    public interface IInterAgencyAgreementsAtBusinessUnit_Item
    {
        int InterAgencyAgreementID { get; set; }
        string Code { get; set; }
        string Description { get; set; }
        long BusinessUnitID { get; set; }
        string Acronym { get; set; }
        string BusinessUnitName { get; set; }
        bool BusinessUnitActive { get; set; }
        bool InterAgencyAgreementBusinessUnitActive { get; set; }
    }
}
