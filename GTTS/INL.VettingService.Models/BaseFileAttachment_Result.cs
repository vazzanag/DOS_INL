using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class BaseFileAttachment_Result : IBaseFileAttachment_Result
    {
        public List<IBaseFileAttachment_Item> files { get; set; }
    }
}
