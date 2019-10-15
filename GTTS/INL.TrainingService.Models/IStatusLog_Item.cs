using System;

namespace INL.TrainingService.Models
{
    public interface IStatusLog_Item
    {
        long TrainingEventStatusLogID { get; set; }
        long TrainingEventID { get; set; }
        int TrainingEventStatusID { get; set; }
        string TrainingEventStatus { get; set; }
        string ReasonStatusChanged { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
