using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipants_Result : IGetTrainingEventParticipants_Result
    {
        public List<GetTrainingEventParticipant_Item> Collection { get; set; }
    }
}
