using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class SaveVettingHit_Param : ISaveVettingHit_Param
    {
        public int? VettingHitID { get; set; }
        public long PersonsVettingID { get; set; }
        public int VettingTypeID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public int? DOBMonth { get; set; }
        public int? DOBDay { get; set; }
        public int? DOBYear { get; set; }
        public string PlaceOfBirth { get; set; }
        public int? ReferenceSiteID { get; set; }
        public int? HitMonth { get; set; }
        public int? HitDay { get; set; }
        public int? HitYear { get; set; }
        public string TrackingID { get; set; }
        public string HitUnit { get; set; }
        public string HitLocation { get; set; }
        public int? ViolationTypeID { get; set; }
        public int? CredibilityLevelID { get; set; }
        public string HitDetails { get; set; }
        public string Notes { get; set; }
        public int? HitResultID { get; set; }
        public string HitResultDetails { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public bool? IsRemoved { get; set; }
    }
}
