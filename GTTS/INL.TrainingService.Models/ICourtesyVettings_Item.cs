using System;

namespace INL.TrainingService.Models
{
    interface ICourtesyVettings_Item
    {
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        long PersonsVettingID { get; set; }
        int? VettingTypeID { get; set; }
        string VettingTypeCode { get; set; }
        bool CourtesyVettingSkipped { get; set; }
        string CourtesyVettingSkippedComments { get; set; }
        int? HitResultID { get; set; }
        string HitResultCode { get; set; }
        string HitResultDetails { get; set; }
    }
}
