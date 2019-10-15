using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonsLeahyVetting_Item
    {
        long LeahyVettingHitID { get; set; }
        long PersonsVettingID { get; set; }
        string CaseID { get; set; }
        byte? LeahyHitResultID { get; set; }
        string LeahyHitResult { get; set; }
        byte? LeahyHitAppliesToID { get; set; }
        string LeahyHitAppliesTo { get; set; }
        byte? ViolationTypeID { get; set; }
        DateTime? CertDate { get; set; }
        DateTime? ExpiresDate { get; set; }
        string Summary { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
