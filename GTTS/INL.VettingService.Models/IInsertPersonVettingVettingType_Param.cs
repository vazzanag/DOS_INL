using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IInsertPersonVettingVettingType_Param
    {
        int PostID { get; set; }
        long VettingBatchID { get; set; }
        int ModifiedAppUserID { get; set; }
    }
}
