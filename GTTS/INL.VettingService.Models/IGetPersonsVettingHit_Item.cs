using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonsVettingHit_Item
    {
        long VettingHitID { get; set; }
        long PersonsVettingID { get; set; }
        int VettingTypeID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        int? DOBYear { get; set; }
        int? DOBMonth { get; set; }
        int? DOBDay { get; set; }
        string PlaceOfBirth { get; set; }
        byte? ReferenceSiteID { get; set; }
        byte? HitMonth { get; set; }
        byte? HitDay { get; set; }
        int? HitYear { get; set; }
        long? UnitID { get; set; }
        string HitUnit { get; set; }
        string HitLocation { get; set; }
        byte? ViolationTypeID { get; set; }
        byte? CredibilityLevelID { get; set; }
        string HitDetails { get; set; }
        string Notes { get; set; }
        byte? HitResultID { get; set; }
        string TrackingID { get; set; }
        string HitResultDetails { get; set; }
        DateTime? VettingHitDate { get; set; }
        string First { get; set; }
        string Middle { get; set; }
        string Last { get; set; } 
        bool IsRemoved { get; set; }
        bool isHistorical { get; set; }
        List<AttachDocumentToVettingHit_Result> VettingHitFileAttachmentJSON { get; set; }
    }
}
