using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPersonsVetting_Item
    {
        long PersonsVettingID { get; set; }
        long PersonID { get; set; }
        int VettingPersonStatusID { get; set; }
        string VettingStatus { get; set; }
        string BatchID { get; set; }
        string TrackingNumber { get; set; }
        DateTime? VettingValidStartDate { get; set; }
        DateTime? VettingValidEndDate { get; set; }
        bool? RemovedFromVetting { get; set; }
    }
}
