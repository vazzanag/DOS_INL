using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPersonVettingVettingType_Param : IGetPersonVettingVettingType_Param
    {
        public long? PersonsVettingID { get; set; }
        public int? VettingTypeID { get; set; }
    }
}
