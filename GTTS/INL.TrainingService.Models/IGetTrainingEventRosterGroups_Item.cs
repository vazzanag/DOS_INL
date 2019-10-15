using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventRosterGroups_Item
    {
        string GroupName { get; set; }
        long TrainingEventGroupID { get; set; }
        List<GetTrainingEventRoster_Item> Rosters { get; set; }
    }
}
