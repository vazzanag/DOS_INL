using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    interface IGetTrainingEvents_Item
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        string NameInLocalLang { get; set; }
        string TrainingEventType { get; set; }
        int? ProgramID { get; set; }
        string BusinessUnitAcronym { get; set; }
        string BusinessUnit { get; set; }
        int? OrganizerAppUserID { get; set; }
        string Organizer { get; set; }
        int? TrainingEventStatusID { get; set; }
        string TrainingEventStatus { get; set; }
        DateTime? EventStartDate { get; set; }
        DateTime? EventEndDate { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string ModifiedByAppUser { get; set; }
        DateTime? ModifiedDate { get; set; }
        DateTime? CreatedDate { get; set; }  

        List<GetTrainingEventLocation_Item> TrainingEventLocations { get; set; }
        List<GetTrainingEventKeyActivity_Item> TrainingEventKeyActivities { get; set; }
    }
}
