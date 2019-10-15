using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IBaseFileAttachment_Result 
    {
        List<IBaseFileAttachment_Item> files { get; set; }
    }
}
