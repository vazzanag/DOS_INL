using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetPersonVettingVettingType_Result : IBaseResult
    {
        IPersonVettingVettingType_Item item { get; set; }
    }
}
