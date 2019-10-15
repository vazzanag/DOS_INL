using INL.Services.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class INKFile_Result : BaseResult, IINKFile_Result
    {
        public string FileName { get; set; }
        public byte[] FileContent { get; set; }
    }
}
