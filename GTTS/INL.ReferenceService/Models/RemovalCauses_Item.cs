using System;

namespace INL.ReferenceService.Models
{
    public class RemovalCauses_Item
    {
        public int RemovalCauseID { get; set; }
        public int RemovalReasonID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime SysStartTime { get; set; }
        public DateTime SysEndTime { get; set; }
    }
}
