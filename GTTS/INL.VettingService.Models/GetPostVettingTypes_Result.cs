using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class GetPostVettingTypes_Result:BaseResult, IGetPostVettingTypes_Result
    {
        public List<GetPostVettingType_Item> items { get; set; }
    }
}
