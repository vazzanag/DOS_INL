using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetPostVettingTypes_Result :IBaseResult
    {
        List<GetPostVettingType_Item> items { get; set; }
    }
}
