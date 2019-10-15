using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventVisaCheckLists_Item : IGetTrainingEventVisaCheckLists_Item
    {
        public long PersonID { get; set; }
        public long? TrainingEventID { get; set; }
        public long? TrainingEventVisaCheckListID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public string AgencyName { get; set; }
        public string VettingStatus { get; set; }
        public bool? HasHostNationCorrespondence { get; set; }
        public bool? HasUSGCorrespondence { get; set; }
        public bool? IsApplicationComplete { get; set; }
        public DateTime? ApplicationSubmittedDate { get; set; }
        public bool? HasPassportAndPhotos { get; set; }
        public string VisaStatus { get; set; }
        public string TrackingNumber { get; set; }
        public string Comments { get; set; }
    }
}
