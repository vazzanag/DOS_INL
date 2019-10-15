using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public interface IHitCredibilityLevels_Item
    {
        int CredibilityLevelID { get; set; }
        string Code {get; set;}
        string Description { get; set; }
        bool IsActive { get; set; }
    }
}
