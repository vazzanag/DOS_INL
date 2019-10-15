using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class BaseFileAttachment_Item : IBaseFileAttachment_Item
    {
        public long FileID { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public byte[] FileHash { get; set; }
        public byte[] FileContent { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
