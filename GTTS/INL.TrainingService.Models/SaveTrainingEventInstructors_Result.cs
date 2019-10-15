using System.Collections.Generic;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventInstructors_Result : BaseResult, ISaveTrainingEventInstructors_Result
    {
        public List<GetTrainingEventInstructor_Item> Collection { get; set; }
    }
}
