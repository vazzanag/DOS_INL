using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventBatch_Item : IGetTrainingEventBatch_Item
    {
        public int BatchNumber { get; set; }
        public List<GetTrainingEventBatchParticipants_Item> Participants { get; set; }
    }
}
