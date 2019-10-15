using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipantsXLSX_Result
    {
        List<TrainingEventParticipantXLSX_Item> Participants { get; set; }
    }
}
