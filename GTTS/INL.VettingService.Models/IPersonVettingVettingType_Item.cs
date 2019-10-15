using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IPersonVettingVettingType_Item
    {
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        long PersonsVettingID { get; set; }
        int VettingTypeID { get; set; }
        string VettingTypeCode { get; set; }
        bool CourtesyVettingSkipped { get; set; }
        string CourtesyVettingSkippedComments { get; set; }
        byte? HitResultID { get; set; }
        string HitResultDetails { get; set; }
        string HitResultCode { get; set; } 
    }
}
