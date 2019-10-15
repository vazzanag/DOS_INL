using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class InsertPersonVettingVettingType_Result : BaseResult, IInsertPersonVettingVettingType_Result
    {
        public List<InsertPersonVettingVettingType_Item> items { get; set; }
    }
}
