using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetVettingBatchesByIDs_Param
    {
        string vettingList { get; set; }
        string courtesyType { get; set; }
        string courtesyStatus { get; set; }
    }
}
