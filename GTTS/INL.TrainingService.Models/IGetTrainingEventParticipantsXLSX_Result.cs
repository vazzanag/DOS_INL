using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipantsXLSX_Result
    {
        List<TrainingEventParticipantXLSX_Item> Participants { get; set; }
    }
}
