using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventParticipantsXLSX_Result : IGetTrainingEventParticipantsXLSX_Result
    {
        public List<TrainingEventParticipantXLSX_Item> Participants { get; set; }
    }
}
