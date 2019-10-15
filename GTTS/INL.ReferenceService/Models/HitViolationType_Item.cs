using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class HitViolationType_Item : IHitViolationType_Item
    {
        public int ViolationTypeID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
