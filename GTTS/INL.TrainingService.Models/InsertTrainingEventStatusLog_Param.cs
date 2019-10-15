using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class InsertTrainingEventStatusLog_Param : IInsertTrainingEventStatusLog_Param
    {
        public long? TrainingEventID { get; set; }
        public string TrainingEventStatus { get; set; }
        public string ReasonStatusChanged { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
