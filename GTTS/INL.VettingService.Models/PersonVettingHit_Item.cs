using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class PersonVettingHit_Item : IPersonVettingHit_Item
    { 
        public int VettingTypeID { get; set; }
        public int NumHits { get; set; }
        public int NumResultHits { get; set; }
        public string VettingTypeCode { get; set; }
    }
}
