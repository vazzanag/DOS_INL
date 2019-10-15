using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ISavePersonsVettingStatus_Param
    {
        long? PersonsVettingID { get; set; }
        string VettingStatus { get; set; }
        bool? IsClear { get; set; }
        bool? IsDeny { get; set; }
        int? ModifiedAppUserID { get; set; }
    }
}
