using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class UncancelTrainingEvent_Param : IStatusLogInsert_Param
    {
        public long? TrainingEventID { get; set; }
        public string ReasonStatusChanged { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
