using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class TrainingEventStudent_Item : ITrainingEventStudent_Item
    {
        public long PersonID { get; set; }
        public long TrainingEventID { get; set; }
        public bool? IsVIP { get; set; }
        public bool? IsParticipant { get; set; }
        public bool? IsTraveling { get; set; }
        public int? DepartureCityID { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public int? VisaStatusID { get; set; }
        public bool? HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
		public bool? OtherVetting { get; set; }
        public bool? PassedOtherVetting { get; set; }
        public string OtherVettingDescription { get; set; }
        public DateTime? OtherVettingDate { get; set; }
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
