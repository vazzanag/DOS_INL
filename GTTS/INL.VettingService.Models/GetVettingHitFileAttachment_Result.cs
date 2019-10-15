using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetVettingHitFileAttachment_Result
    {
        public long VettingHitFileAttachmentID { get; set; }
        public long VettingHitID { get; set; }
        public int FileVersion { get; set; }
        public string FileName { get; set; }
        public int FileSize { get; set; }
        public byte[] FileHash { get; set; }
        public byte[] FileContent { get; set; }
        public string ThumbnailPath { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string ModifiedByUserJSON { get; set; }
    }
}
