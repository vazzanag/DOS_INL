using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IGetPersonVettingVettingTypes_Result
    {
        List<GetPersonVettingVettingType_Item> Collection { get; set; }
    }
}
