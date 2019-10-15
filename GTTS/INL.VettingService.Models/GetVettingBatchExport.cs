
namespace INL.VettingService.Models
{
    public class GetVettingBatchExport : IGetVettingBatchExport
    {
        public string FileName { get; set; }
        public byte[] FileContent { get; set; }
    }
}
