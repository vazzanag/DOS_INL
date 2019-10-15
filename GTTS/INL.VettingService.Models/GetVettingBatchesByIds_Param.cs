using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetVettingBatchesByIDs_Param : IGetVettingBatchesByIDs_Param
    {
        public string vettingList { get; set; }
        public string courtesyType { get; set; }
        public string courtesyStatus { get; set; }
    }
}
