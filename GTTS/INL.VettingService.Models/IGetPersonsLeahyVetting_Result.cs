using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetPersonsLeahyVetting_Result : IBaseResult
    {
        GetPersonsLeahyVetting_Item item { get; set; }
    }
}
