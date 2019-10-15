using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IGetInvestVettingBatch_Result : IBaseResult
    {
        List<InvestVettingBatch_Item> InvestVettingBatchItems { get; set; }
        int FileVersion { get; set; }
        string FileName { get; set; }
        int FileSize { get; set; }
        byte[] FileHash { get; set; }
        byte[] FileContent { get; set; }
    }
}
