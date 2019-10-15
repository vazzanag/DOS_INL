using System;

namespace INL.TrainingService.Models
{
    public class CourtesyVettings_Item : ICourtesyVettings_Item
    {
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public long PersonsVettingID { get; set; }
        public int? VettingTypeID { get; set; }
        public string VettingTypeCode { get; set; }
        public bool CourtesyVettingSkipped { get; set; }
        public string CourtesyVettingSkippedComments { get; set; }
        public int? HitResultID { get; set; }
        public string HitResultCode { get; set; }
        public string HitResultDetails { get; set; }
    }
}
