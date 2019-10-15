using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetPersonsVettingHit_Result : IBaseResult
    {
        long PersonsVettingID { get; set; }
        int VettingTypeID { get; set; }
        int HitResultID { get; set; }
        string HitResultDetails { get; set; }
        List<GetPersonsVettingHit_Item> items { get; set; }
    }
}
