using System;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventKeyActivity_Item : IGetTrainingEventKeyActivity_Item
    {
        public int KeyActivityID { get; set; }
        public long TrainingEventID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
