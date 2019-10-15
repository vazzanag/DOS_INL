using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnitAlias_Item : IGetUnitAlias_Item
    {
        public int UnitAliasID { get; set; }
        public long UnitID { get; set; }
        public string UnitAlias { get; set; }
        public int? LanguageID { get; set; }
        public bool IsDefault { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
