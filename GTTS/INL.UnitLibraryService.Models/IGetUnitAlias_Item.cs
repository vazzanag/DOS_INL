using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnitAlias_Item
    {
        int UnitAliasID { get; set; }
        long UnitID { get; set; }
        string UnitAlias { get; set; }
        int? LanguageID { get; set; }
        bool IsDefault { get; set; }
        bool IsActive { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
