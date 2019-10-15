using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class GetPostVettingType_Item :IGetPostVettingType_Item
    {
        public int PostID { get; set; }
        public int VettingTypeID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
