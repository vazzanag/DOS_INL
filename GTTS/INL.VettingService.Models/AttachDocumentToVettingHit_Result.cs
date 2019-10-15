using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class AttachDocumentToVettingHit_Result
    {
        public long VettingHitFileAttachmentID { get; set; }
        public long VettingHitID { get; set; }
        public int FileVersion { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string DownloadURL { get; set; }
    }
}
