using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventVettingPreviewBatches_Result : IGetTrainingEventVettingPreviewBatches_Result
    {
        public int MaxBatchSize { get; set; }
        public int LeahyBatchLeadTime { get; set; }
        public int CourtesyBatchLeadTime { get; set; }
        public List<GetTrainingEventBatch_Item> LeahyBatches { get; set; }
        public List<GetTrainingEventBatch_Item> CourtesyBatches { get; set; }
        public List<GetTrainingEventBatch_Item> LeahyReVettingBatches { get; set; }
        public List<GetTrainingEventBatch_Item> CourtesyReVettingBatches { get; set; }
    }
}
