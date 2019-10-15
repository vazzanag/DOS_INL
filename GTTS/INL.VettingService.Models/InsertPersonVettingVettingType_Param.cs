using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class InsertPersonVettingVettingType_Param : IInsertPersonVettingVettingType_Param
    {
        public int PostID { get; set; }
        public long VettingBatchID { get; set; }
        public int ModifiedAppUserID { get; set; }
    }
}
