using System;
using System.Collections.Generic;
using System.IO;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipantsXLSX_Param : ISaveTrainingEventParticipantsXLSX_Param
    {
        public Int64? TrainingEventID { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public Stream ParticipantsExcelStream { get; set; }
        public List<TrainingEventParticipantXLSX_Item> Participants { get; set; }

        public SaveTrainingEventParticipantsXLSX_Param()
        {
            Participants = new List<TrainingEventParticipantXLSX_Item>();
        }
    }
}
