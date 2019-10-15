using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class SavePersonVettingVettingType_Param : ISavePersonVettingVettingType_Param
    {
        public long? PersonVettingID { get; set; }
        public int? VettingTypeID { get; set; }
        public bool? CourtesySkippedFlag { get; set; }
        public string CourtesySkippedComments { get; set; }
        public int? ModifiedAppUserID { get; set; }
    }
}
