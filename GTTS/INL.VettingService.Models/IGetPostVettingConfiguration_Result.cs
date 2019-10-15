using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPostVettingConfiguration_Result
	{
		int PostID { get; set; }
		int MaxBatchSize { get; set; }
        int LeahyBatchLeadTime { get; set; }
        int CourtesyBatchLeadTime { get; set; }
        int LeahyBatchExpirationIntervalMonths { get; set; }
        int CourtesyBatchExpirationIntervalMonths { get; set; }
    }
}
