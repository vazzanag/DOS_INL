using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class GetCourtesyBatch_Result : BaseResult, IGetCourtesyBatch_Result
    {
        public ICourtesyBatch_Item item { get; set; }
    }
}
