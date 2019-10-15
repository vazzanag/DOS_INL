using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventParticipants_Param 
    {
        long TrainingEventID { get; set; }
        int ModifiedByAppUserID { get; set; }
        List<TrainingEventStudent_Item> Collection { get; set; }
    }
}
