using System;

namespace INL.VettingService.Models
{
    public class PersonVettingStatus_Item : IPersonVettingStatus_Item
    {
        public long PersonID { get; set; }
        public long? TrainingEventID { get; set; }
        public int VettingBatchStatusID { get; set; }
        public string BatchStatus { get; set; }
        public int VettingPersonStatusID { get; set; }
        public string PersonsVettingStatus { get; set; }
        public DateTime? DateLeahyFileGenerated { get; set; }
        public DateTime? VettingBatchStatusDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public bool RemovedFromVetting { get; set; }
        public DateTime? VettingStatusDate { get; set; }
        public int VettingBatchTypeID { get; set; }
    }
}
