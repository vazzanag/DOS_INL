using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IPersonVettingType_Item
    {
        int NumParticipants { get; set; }
        string VettingTypeCode { get; set; }
        int VettingTypeID { get; set; }
    }
}
