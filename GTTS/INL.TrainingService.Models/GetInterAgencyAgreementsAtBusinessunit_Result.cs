using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetInterAgencyAgreementsAtBusinessunit_Result : IGetInterAgencyAgreementsAtBusinessunit_Result
    {
        public List<InterAgencyAgreementsAtBusinessUnit_Item> Collection { get; set; }
    }
}
