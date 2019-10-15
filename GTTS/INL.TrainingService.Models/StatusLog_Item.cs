using System;

namespace INL.TrainingService.Models
{
    public class StatusLog_Item : IStatusLog_Item
    {
        public long TrainingEventStatusLogID { get; set; }
        public long TrainingEventID { get; set; }
        public int TrainingEventStatusID { get; set; }
        public string TrainingEventStatus { get; set; }
        public string ReasonStatusChanged { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
