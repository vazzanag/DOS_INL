using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ISaveLeahyVettingHit_Param
    {
        long? LeahyVettingHitID { get; set; }
        long? PersonsVettingID { get; set; }
        string CaseID { get; set; }
        byte? LeahyHitResultID { get; set; }
        byte? LeahyHitAppliesToID { get; set; }
        byte? ViolationTypeID { get; set; }
        DateTime? CertDate { get; set; }
        DateTime? ExpiresDate { get; set; }
        string Summary { get; set; }
        long? ModifiedByAppUserID { get; set; }
    }
}
