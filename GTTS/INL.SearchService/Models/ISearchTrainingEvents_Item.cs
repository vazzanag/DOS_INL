using System;
using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchTrainingEvents_Item
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        string NameInLocalLang { get; set; }
        int CountryID { get; set; }
        long? TrainingUnitID { get; set; }
        string TrainingUnitAcronym { get; set; }
        string TrainingUnit { get; set; }
        int? OrganizerAppUserID { get; set; }
        string OrganizerFullName { get; set; }
        int ParticipantCount { get; set; }
        string TrainingEventType { get; set; }
        int? TrainingEventStatusID { get; set; }
        string TrainingEventStatus { get; set; }
        DateTime? EventStartDate { get; set; }
        DateTime? EventEndDate { get; set; }
        List<SearchTrainingEventLocations_Item> Locations { get; set; }
        List<SearchTrainingEventKeyActivities_Item> KeyActivities { get; set; }
    }
}
