using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPersonsVettingHit_Item : IGetPersonsVettingHit_Item
    {
        public long VettingHitID { get; set; }
        public long PersonsVettingID { get; set; }
        public int VettingTypeID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public int? DOBYear { get; set; }
        public int? DOBMonth { get; set; }
        public int? DOBDay { get; set; }
        public string PlaceOfBirth { get; set; }
        public byte? ReferenceSiteID { get; set; }
        public byte? HitMonth { get; set; }
        public byte? HitDay { get; set; }
        public int? HitYear { get; set; }
        public long? UnitID { get; set; }
        public string HitUnit { get; set; }
        public string HitLocation { get; set; }
        public byte? ViolationTypeID { get; set; }
        public byte? CredibilityLevelID { get; set; }
        public string HitDetails { get; set; } 
        public string Notes { get; set; }
        public string TrackingID { get; set; }
        public byte? HitResultID { get; set; }
        public string HitResultDetails { get; set; }
        public DateTime? VettingHitDate { get; set; }
        public string First { get; set; }
        public string Middle { get; set; }
        public string Last { get; set; }
        public bool IsRemoved { get; set; }
        public bool isHistorical { get; set; }
        public List<AttachDocumentToVettingHit_Result> VettingHitFileAttachmentJSON { get; set; }
    }
}
