using System;

namespace INL.VettingService.Models
{
    public interface IPersonVettingStatus_Item
    {
        long PersonID { get; set; }
        long? TrainingEventID { get; set; }
        int VettingBatchStatusID { get; set; }
        string BatchStatus { get; set; }
        int VettingPersonStatusID { get; set; }
        string PersonsVettingStatus { get; set; }
        DateTime? DateLeahyFileGenerated { get; set; }
        DateTime? VettingBatchStatusDate { get; set; }
        DateTime? ExpirationDate { get; set; }
        bool RemovedFromVetting { get; set; }
        DateTime? VettingStatusDate { get; set; }
        int VettingBatchTypeID { get; set; }
    }
}
