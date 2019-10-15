using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventInstructors_Param : ISaveTrainingEventInstructors_Param
    {
        public long TrainingEventID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public List<TrainingEventInstructor_Item> Collection { get; set; }
    }
}
