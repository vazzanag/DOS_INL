using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class LeahyHit_Item
    {
        public long LeahyVettingHitID { get; set; }
        public long PersonsVettingID { get; set; }
        public string CaseID { get; set; }
        public byte? LeahyHitResultID { get; set; }
        public string LeahyHitResult { get; set; }
        public byte? LeahyHitAppliesToID { get; set; }
        public string LeahyHitAppliesTo { get; set; }
        public byte? ViolationTypeID { get; set; }
        public DateTime? CertDate { get; set; }
        public DateTime? ExpiresDate { get; set; }
        public string Summary { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
