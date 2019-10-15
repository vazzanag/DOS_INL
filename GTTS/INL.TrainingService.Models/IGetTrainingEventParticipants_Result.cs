using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipants_Result
    {
        List<GetTrainingEventParticipant_Item> Collection { get; set; }
    }
}
