using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipant_PartialResult : ISaveTrainingEventParticipant_PartialResult
    {
        public Int64 PersonID { get; set; }
        public Int64 TrainingEventID { get; set; }
    }
}
