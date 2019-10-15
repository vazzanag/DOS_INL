using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IPersonVettingHit_Item
    {
        int VettingTypeID { get; set; }
        int NumHits { get; set; }
        int NumResultHits { get; set; }
        string VettingTypeCode { get; set; }
    }
}
