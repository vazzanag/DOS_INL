using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class PersonVettingType_Item : IPersonVettingType_Item
    { 
        public int NumParticipants { get; set; }
        public string VettingTypeCode { get; set; }
        public int VettingTypeID { get; set; }
    }
}
