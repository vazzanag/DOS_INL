using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventVettingPreviewBatches_Result
    {
        int MaxBatchSize { get; set; }
        int LeahyBatchLeadTime { get; set; }
        int CourtesyBatchLeadTime { get; set; }
        List<GetTrainingEventBatch_Item> LeahyBatches { get; set; }
        List<GetTrainingEventBatch_Item> CourtesyBatches { get; set; }
        List<GetTrainingEventBatch_Item> LeahyReVettingBatches { get; set; }
        List<GetTrainingEventBatch_Item> CourtesyReVettingBatches { get; set; }
    }
}
