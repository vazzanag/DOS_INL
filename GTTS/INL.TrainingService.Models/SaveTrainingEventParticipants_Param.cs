using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipants_Param : ISaveTrainingEventParticipants_Param
    {
        public long TrainingEventID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public List<TrainingEventStudent_Item> Collection { get; set; }
    }
}
