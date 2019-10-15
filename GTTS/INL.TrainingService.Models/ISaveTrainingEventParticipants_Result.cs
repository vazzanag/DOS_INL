using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipants_Result 
    {
        List<SaveTrainingEventParticipants_Item> Collection { get; set; }
    }
}
