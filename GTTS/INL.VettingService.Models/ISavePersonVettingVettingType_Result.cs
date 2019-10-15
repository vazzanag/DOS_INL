using System;
using System.Collections.Generic;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface ISavePersonVettingVettingType_Result : IBaseResult
    {
        IPersonVettingVettingType_Item item { get; set; }
    }
}
