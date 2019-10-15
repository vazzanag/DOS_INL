using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ITrainingEventStudent_Item
    {
        long PersonID { get; set; }
        long TrainingEventID { get; set; }
        bool? IsVIP { get; set; }
        bool? IsParticipant { get; set; }
        bool? IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VisaStatusID { get; set; }
        bool? HasLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
		bool? OtherVetting { get; set; }
		bool? PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
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
