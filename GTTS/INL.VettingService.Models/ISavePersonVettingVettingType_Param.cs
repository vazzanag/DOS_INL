using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ISavePersonVettingVettingType_Param
    {
        long? PersonVettingID { get; set; }
        int? VettingTypeID { get; set; }
        bool? CourtesySkippedFlag { get; set; }
        string CourtesySkippedComments { get; set; }
        int? ModifiedAppUserID { get; set; }

    }
}

