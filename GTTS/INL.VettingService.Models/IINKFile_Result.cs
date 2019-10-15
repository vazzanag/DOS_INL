using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IINKFile_Result
    {
        string FileName { get; set; }
        byte[] FileContent { get; set; }
    }
}
