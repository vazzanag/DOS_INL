using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class HitResult_Item : IHitResult_Item
    {
        public int HitResultID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
