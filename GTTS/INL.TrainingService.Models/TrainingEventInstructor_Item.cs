using System;

namespace INL.TrainingService.Models
{
    public class TrainingEventInstructor_Item : ITrainingEventInstructor_Item
    {
        public long PersonID { get; set; }
        public long TrainingEventID { get; set; }
        public long? PersonsVettingID { get; set; }
        public bool IsTraveling { get; set; }
        public int? DepartureCityID { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public int? VisaStatusID { get; set; }
        public int? PaperworkStatusID { get; set; }
        public int? TravelDocumentStatusID { get; set; }
        public bool RemovedFromEvent { get; set; }
        public int? RemovalReasonID { get; set; }
        public int? RemovalCauseID { get; set; }
        public DateTime? DateCanceled { get; set; }
        public string Comments { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
