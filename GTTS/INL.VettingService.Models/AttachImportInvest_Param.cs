using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class AttachImportInvest_Param : IAttachImportInvest_Param
    {
        public long VettingBatchID { get; set; }
        public long FileID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public string FileName { get; set; }
    }
}
