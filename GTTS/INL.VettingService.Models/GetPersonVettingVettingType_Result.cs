using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;
//using INL.VettingService.Client.Models;

namespace INL.VettingService.Models
{
    public class GetPersonVettingVettingType_Result : BaseResult, IGetPersonVettingVettingType_Result
    {
        public IPersonVettingVettingType_Item item { get; set; }
    }
}
