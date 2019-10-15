using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface ISaveUnitAlias_Item
    {
        int UnitAliasID { get; set; }
        long UnitID { get; set; }
        string UnitAlias { get; set; }
        short? LanguageID { get; set; }
        int ModifiedByAppUserID { get; set; }
        bool IsDefault { get; set; }
        bool IsActive { get; set; }
    }
}
