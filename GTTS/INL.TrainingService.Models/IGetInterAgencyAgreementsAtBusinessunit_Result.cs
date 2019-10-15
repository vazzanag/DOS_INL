using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetInterAgencyAgreementsAtBusinessunit_Result
    {
        List<InterAgencyAgreementsAtBusinessUnit_Item> Collection { get; set; }
    }
}
