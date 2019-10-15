using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IBaseFileAttachment_Item
    {
        long FileID { get; set; }
        string FileName { get; set; }
        int FileSize { get; set; }
        byte[] FileHash { get; set; }
        byte[] FileContent { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}
