using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class HitCredibilityLevels_Item: IHitCredibilityLevels_Item
    {
        public int CredibilityLevelID { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
