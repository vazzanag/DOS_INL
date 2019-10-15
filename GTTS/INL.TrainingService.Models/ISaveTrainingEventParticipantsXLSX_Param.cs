using System;
using System.Collections.Generic;
using System.IO;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipantsXLSX_Param
    {
        Int64? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        Stream ParticipantsExcelStream { get; set; }
        List<TrainingEventParticipantXLSX_Item> Participants { get; set; }
    }
}
