using System;

namespace INL.TrainingService.Models
{
    public interface ITrainingEventInstructor_Item
    {
        long PersonID { get; set; }
        long TrainingEventID { get; set; }
        long? PersonsVettingID { get; set; }
        bool IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VisaStatusID { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        int? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
