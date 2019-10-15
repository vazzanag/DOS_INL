using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventRoster_Result : BaseResult, ISaveTrainingEventRoster_Result
    {
        public long TrainingEventID { get; set; }
        public long? TrainingEventGroupID { get; set; }
        public List<ITrainingEventRoster_Item> Students { get; set; }
    }
}
