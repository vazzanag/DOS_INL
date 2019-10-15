using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipant_PartialResult
    {
        Int64 PersonID { get; set; }
        Int64 TrainingEventID { get; set; }
    }
}
