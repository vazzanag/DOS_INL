using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class ImportInvestFileResult : BaseResult
    {
        public List<LeahyHit_Item> Items { get; set; }
    }
}
