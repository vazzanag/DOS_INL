using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonVettingVettingType_Item
    {
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        long PersonsVettingID { get; set; }
        int? VettingTypeID { get; set; }
        string VettingTypeCode { get; set; }
        bool? CourtesyVettingSkipped { get; set; }
        string CourtestVettingSkippedComments { get; set; }
    }
}
