using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class GetPersonVettingVettingTypes_Result : IGetPersonVettingVettingTypes_Result
    {
        public List<GetPersonVettingVettingType_Item> Collection { get; set; }
    }
}
