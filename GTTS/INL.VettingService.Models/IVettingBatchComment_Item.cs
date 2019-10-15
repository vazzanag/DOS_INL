using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IVettingBatchComment_Item
    {
        long VettingBatchID { get; set; }
        long VettingBatchCommentID { get; set; }
        string VettingBatchComments { get; set; }
        int VettingTypeID { get; set; }
    }
}
