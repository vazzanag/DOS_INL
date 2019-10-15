
namespace INL.VettingService.Models
{
    public interface IGetVettingBatchExport
    {
        string FileName { get; set; }
        byte[] FileContent { get; set; }
    }
}
