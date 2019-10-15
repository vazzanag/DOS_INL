using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventRosterInGroups_Result
    {
        long TrainingEventID { get; set; }
        List<IGetTrainingEventRosterGroups_Item> RosterGroups { get; set; }
    }
}
