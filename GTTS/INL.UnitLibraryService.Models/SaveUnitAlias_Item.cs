using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class SaveUnitAlias_Item : ISaveUnitAlias_Item
    {
        public int UnitAliasID { get; set; }
        public long UnitID { get; set; }
        public string UnitAlias { get; set; }
        public short? LanguageID { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public bool IsDefault { get; set; }
        public bool IsActive { get; set; }
    }
}
