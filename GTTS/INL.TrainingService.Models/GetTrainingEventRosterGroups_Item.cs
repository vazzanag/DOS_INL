using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventRosterGroups_Item : IGetTrainingEventRosterGroups_Item
    {
        public string GroupName { get; set; }
        public long TrainingEventGroupID { get; set; }
        public List<GetTrainingEventRoster_Item> Rosters { get; set; }
    }
}
