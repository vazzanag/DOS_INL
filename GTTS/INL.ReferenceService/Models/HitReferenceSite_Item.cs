﻿using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class HitReferenceSite_Item : IHitReferenceSite_Item
    {
        public int ReferenceSiteID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
