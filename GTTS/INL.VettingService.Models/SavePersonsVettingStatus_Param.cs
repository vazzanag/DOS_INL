using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class SavePersonsVettingStatus_Param : ISavePersonsVettingStatus_Param
    {
        public long? PersonsVettingID { get; set; }
        public string VettingStatus { get; set; }
        public bool? IsClear { get; set; }
        public bool? IsDeny { get; set; }
        public int? ModifiedAppUserID { get; set; }
    }
}
