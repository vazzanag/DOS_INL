using INL.Services.Models;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipantsXLSX_Result : ISaveTrainingEventParticipantsXLSX_Result
    {
        public List<TrainingEventParticipantXLSX_Item> Participants { get; set; }  
    }
}
