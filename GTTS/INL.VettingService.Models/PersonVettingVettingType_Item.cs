using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class PersonVettingVettingType_Item : IPersonVettingVettingType_Item
    {
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public long PersonsVettingID { get; set; }
        public int VettingTypeID { get; set; }
        public string VettingTypeCode { get; set; }
        public bool CourtesyVettingSkipped { get; set; }
        public string CourtesyVettingSkippedComments { get; set; }
        public byte? HitResultID { get; set; }
        public string HitResultDetails { get; set; }
        public string HitResultCode { get; set; }
    }
}
