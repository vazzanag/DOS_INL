using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetCourtesyFile_Result : IBaseResult
    {
        long FileID { get; set; }
        int FileVersion { get; set; }
        string FileName { get; set; }
        int FileSize { get; set; }
        byte[] FileHash { get; set; }
        byte[] FileContent { get; set; }
    }
}
