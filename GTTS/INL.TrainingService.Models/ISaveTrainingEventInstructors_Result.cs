using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventInstructors_Result
    {
        List<GetTrainingEventInstructor_Item> Collection { get; set; }
    }
}
