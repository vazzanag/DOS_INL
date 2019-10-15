using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IAttachImportInvest_Param
    {
        long VettingBatchID { get; set; }
        long FileID { get; set; }
        int ModifiedByAppUserID { get; set; }
        string FileName { get; set; }
    }
}
