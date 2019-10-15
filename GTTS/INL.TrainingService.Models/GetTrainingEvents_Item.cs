using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEvents_Item : IGetTrainingEvents_Item
    {
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public string NameInLocalLang { get; set; }
        public string TrainingEventType { get; set; }
        public int? ProgramID { get; set; }
        public string BusinessUnitAcronym { get; set; }
        public string BusinessUnit { get; set; }
        public int? OrganizerAppUserID { get; set; }
        public string Organizer { get; set; }
        public int? TrainingEventStatusID { get; set; }
        public string TrainingEventStatus { get; set; }
        public DateTime? EventStartDate { get; set; }
        public DateTime? EventEndDate { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public string ModifiedByAppUser { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? CreatedDate { get; set; }

        public List<GetTrainingEventLocation_Item> TrainingEventLocations { get; set; }
        public List<GetTrainingEventKeyActivity_Item> TrainingEventKeyActivities { get; set; }
    }
}
