using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public interface IHitViolationType_Item
    {
        int ViolationTypeID { get; set; }
        string Code { get; set; }
        string Description { get; set; }
        bool IsActive { get; set; }
    }
}
