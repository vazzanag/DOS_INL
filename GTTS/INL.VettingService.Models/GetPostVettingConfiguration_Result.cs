using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPostVettingConfiguration_Result : IGetPostVettingConfiguration_Result
    {
        public int PostID { get; set; }
        public int MaxBatchSize { get; set; }
        public int LeahyBatchLeadTime { get; set; }
        public int CourtesyBatchLeadTime { get; set; }
        public int LeahyBatchExpirationIntervalMonths { get; set; }
        public int CourtesyBatchExpirationIntervalMonths { get; set; }
    }
}
