using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonVettingVettingType_Param
    {
        long? PersonsVettingID { get; set; }
        int? VettingTypeID { get; set; }
    }
}
