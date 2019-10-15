using System;

namespace INL.TrainingService.Models
{
    public class GetPersonsTrainingEvent_Item : IGetPersonsTrainingEvent_Item
    {
        public long TrainingEventID { get; set; }
        public string Name { get; set; }
        public long PersonID { get; set; }
        public string ParticipantType { get; set; }
        public DateTime? EventStartDate { get; set; }
        public DateTime? EventEndDate { get; set; }
        public string BusinessUnitAcronym { get; set; }
        public string TrainingEventRosterDistinction { get; set; }
        public bool? Certificate { get; set; }
        public string TrainingEventStatus { get; set; }
    }
}
