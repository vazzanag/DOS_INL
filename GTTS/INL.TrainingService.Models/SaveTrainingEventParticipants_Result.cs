using System.Collections.Generic;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventParticipants_Result : BaseResult, ISaveTrainingEventParticipants_Result
    {
        public List<SaveTrainingEventParticipants_Item> Collection { get; set; }
    }
}
