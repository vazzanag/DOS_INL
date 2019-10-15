using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventRoster_Result
    {
        long TrainingEventID { get; set; }
        List<GetTrainingEventRoster_Item> Rosters { get; set; }
    }
}
