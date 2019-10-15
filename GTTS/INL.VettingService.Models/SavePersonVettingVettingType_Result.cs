using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class SavePersonVettingVettingType_Result : BaseResult, ISavePersonVettingVettingType_Result
    {
        public IPersonVettingVettingType_Item item { get; set; }
    }
}
