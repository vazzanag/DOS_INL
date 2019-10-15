using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventRosterInGroups_Result : IGetTrainingEventRosterInGroups_Result
    {
        public long TrainingEventID { get; set; }
        public List<IGetTrainingEventRosterGroups_Item> RosterGroups { get; set; }
    }
}
