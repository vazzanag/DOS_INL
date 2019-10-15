using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class GetPersonsLeahyVetting_Result : BaseResult, IGetPersonsLeahyVetting_Result
    {
        public GetPersonsLeahyVetting_Item item { get; set; }
    }
}
