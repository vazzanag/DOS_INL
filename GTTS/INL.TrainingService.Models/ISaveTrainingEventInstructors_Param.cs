using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventInstructors_Param
    {
        long TrainingEventID { get; set; }
        int ModifiedByAppUserID { get; set; }
        List<TrainingEventInstructor_Item> Collection { get; set; }
    }
}
