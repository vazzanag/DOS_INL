using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPersonsVetting_Item : IGetPersonsVetting_Item
    {
        public long PersonsVettingID { get; set; }
        public long PersonID { get; set; }
        public int VettingPersonStatusID { get; set; }
        public string VettingStatus { get; set; }
        public string BatchID { get; set; }
        public string TrackingNumber { get; set; }
        public DateTime? VettingValidStartDate { get; set; }
        public DateTime? VettingValidEndDate { get; set; }
        public bool? RemovedFromVetting { get; set; }
    }
}
