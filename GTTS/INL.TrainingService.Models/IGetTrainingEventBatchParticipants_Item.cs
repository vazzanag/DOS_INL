using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventBatchParticipants_Item : IGetTrainingEventParticipant_Item
    {
        string WorkEmailAddress { get; set; }
        bool IsUnitCommander { get; set; }
    }
}
