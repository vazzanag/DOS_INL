using System;
using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class SearchTrainingEvents_Item : ISearchTrainingEvents_Item
    {
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public string NameInLocalLang { get; set; }
        public int CountryID { get; set; }
        public long? TrainingUnitID { get; set; }
        public string TrainingUnitAcronym { get; set; }
        public string TrainingUnit { get; set; }
        public int? OrganizerAppUserID { get; set; }
        public string OrganizerFullName { get; set; }
        public int ParticipantCount { get; set; }
        public string TrainingEventType { get; set; }
        public int? TrainingEventStatusID { get; set; }
        public string TrainingEventStatus { get; set; }
        public DateTime? EventStartDate { get; set; }
        public DateTime? EventEndDate { get; set; }
        public List<SearchTrainingEventLocations_Item> Locations { get; set; }
        public List<SearchTrainingEventKeyActivities_Item> KeyActivities { get; set; }
    }
}
