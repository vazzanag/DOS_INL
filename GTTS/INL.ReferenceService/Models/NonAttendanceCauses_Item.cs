using System;

namespace INL.ReferenceService.Models
{
    public class NonAttendanceCauses_Item
    {
        public byte NonAttendanceCauseID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
