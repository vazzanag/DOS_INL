using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventVisaCheckLists_Item
    {
        long PersonID { get; set; }
        long? TrainingEventID { get; set; }
        long? TrainingEventVisaCheckListID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        string AgencyName { get; set; }
        string VettingStatus { get; set; }
        bool? HasHostNationCorrespondence { get; set; }
        bool? HasUSGCorrespondence { get; set; }
        bool? IsApplicationComplete { get; set; }
        DateTime? ApplicationSubmittedDate { get; set; }
        bool? HasPassportAndPhotos { get; set; }
        string VisaStatus { get; set; }
        string TrackingNumber { get; set; }
        string Comments { get; set; }
    }
}
