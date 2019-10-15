using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class GetInvestVettingBatch_Result : BaseResult, IGetInvestVettingBatch_Result
    {
        public List<InvestVettingBatch_Item> InvestVettingBatchItems { get; set; }
        public int FileVersion { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public byte[] FileHash { get; set; }
        public byte[] FileContent { get; set; }
    }
}
