using System;

namespace INL.PersonService.Models
{
    public interface IGetPersonsTraining_Item 
    {
        long TrainingEventID { get; set; }
        string Name { get; set; }
        long PersonID { get; set; }
        string ParticipantType { get; set; }
        DateTime? EventStartDate { get; set; }
        DateTime? EventEndDate { get; set; }
        string BusinessUnitAcronym { get; set; }
        string TrainingEventRosterDistinction { get; set; }
        bool? Certificate { get; set; }
        string TrainingEventStatus { get; set; }
    }
}
