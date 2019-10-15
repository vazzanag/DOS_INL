using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventRoster_Result : IGetTrainingEventRoster_Result
    {
        public long TrainingEventID { get; set; }
        public List<GetTrainingEventRoster_Item> Rosters { get; set; }
    }
}
