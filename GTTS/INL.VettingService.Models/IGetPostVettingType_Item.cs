using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IGetPostVettingType_Item
    {
        int PostID { get; set; }
        int VettingTypeID { get; set; }
        string Code { get; set; }
        string Description { get; set; }
        bool IsActive { get; set; }
    }
}
