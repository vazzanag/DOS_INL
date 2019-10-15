using System;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventKeyActivity_Item
    {
        int KeyActivityID { get; set; }
        long TrainingEventID { get; set; }
        string Code { get; set; }
        string Description { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
