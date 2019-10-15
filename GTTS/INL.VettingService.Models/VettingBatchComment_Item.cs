using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class VettingBatchComment_Item : IVettingBatchComment_Item
    {
        public long VettingBatchID { get; set; }
        public long VettingBatchCommentID { get; set; }
        public string VettingBatchComments { get; set; }
        public int VettingTypeID { get; set; }
    }
}
