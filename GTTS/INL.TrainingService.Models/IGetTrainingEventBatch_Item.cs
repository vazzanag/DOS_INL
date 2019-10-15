using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventBatch_Item
    {
        int BatchNumber { get; set; }
        List<GetTrainingEventBatchParticipants_Item> Participants { get; set; }
    }
}
