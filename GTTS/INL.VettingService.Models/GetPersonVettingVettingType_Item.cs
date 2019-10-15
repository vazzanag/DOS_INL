using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPersonVettingVettingType_Item : IGetPersonVettingVettingType_Item
    {
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public long PersonsVettingID { get; set; }
        public int? VettingTypeID { get; set; }
        public string VettingTypeCode { get; set; }
        public bool? CourtesyVettingSkipped { get; set; }
        public string CourtestVettingSkippedComments { get; set; }
    }
}
