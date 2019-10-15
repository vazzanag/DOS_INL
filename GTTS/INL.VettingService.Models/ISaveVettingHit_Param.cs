using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ISaveVettingHit_Param
    {
        int? VettingHitID { get; set; }
        long PersonsVettingID { get; set; }
        int VettingTypeID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        int? DOBMonth { get; set; }
        int? DOBDay { get; set; }
        int? DOBYear { get; set; }
        string PlaceOfBirth { get; set; }
        int? ReferenceSiteID { get; set; }
        int? HitMonth { get; set; }
        int? HitDay { get; set; }
        int? HitYear { get; set; }
        string TrackingID { get; set; }
        string HitUnit { get; set; }
        string HitLocation { get; set; }
        int? ViolationTypeID { get; set; }
        int? CredibilityLevelID { get; set; }
        string HitDetails { get; set; }
        string Notes { get; set; }
        int? HitResultID { get; set; }
        string HitResultDetails { get; set; }
        int? ModifiedByAppUserID { get; set; }
        bool? IsRemoved { get; set; }
    }
}
