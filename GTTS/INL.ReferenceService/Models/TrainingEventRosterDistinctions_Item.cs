using System;

namespace INL.ReferenceService.Models
{
    public class TrainingEventRosterDistinctions_Item
    {
        public int TrainingEventRosterDistinctionID { get; set; }
        public int? PostID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
