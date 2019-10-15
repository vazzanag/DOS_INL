using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class GetCourtesyFile_Result : BaseResult, IGetCourtesyFile_Result
    {
        public long FileID { get; set; }
        public int FileVersion { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public byte[] FileHash { get; set; }
        public byte[] FileContent { get; set; }
    }
}
