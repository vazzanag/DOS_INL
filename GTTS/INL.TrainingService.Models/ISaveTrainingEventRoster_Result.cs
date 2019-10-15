using System;
using System.Collections.Generic;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventRoster_Result : IBaseResult
    {
        long TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }
        List<ITrainingEventRoster_Item> Students { get; set; }
    }
}
