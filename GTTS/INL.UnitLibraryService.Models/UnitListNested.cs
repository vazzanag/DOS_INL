using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class UnitListNested
    {
        public string UnitName;
        public string UnitNameEnglish;
        public string UnitGenID;
        public long UnitID;
        public long UnitParentID;
        public string UnitParentNumber;
        public string UnitNumber;
        public List<UnitListNested> children;
    }
}
