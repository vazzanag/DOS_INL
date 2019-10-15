using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class AttachDocumentToVettingHit_Param : BaseFileAttachment_Item
    {
        public long? VettingHitFileAttachmentID { get; set; }
        public long? VettingHitID { get; set; }
        public string Description { get; set; }
        public int FileVersion { get; set; }
    }
}
