using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IInsertPersonVettingVettingType_Result : IBaseResult
    {
        List<InsertPersonVettingVettingType_Item> items { get; set; }
    }
}
