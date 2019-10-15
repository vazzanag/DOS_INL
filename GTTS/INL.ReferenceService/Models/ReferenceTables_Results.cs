using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class ReferenceTables_Results
    {
        public ReferenceTables_Results()
        {
            Collection = new List<ReferenceTables_Item>();
        }
        public List<ReferenceTables_Item> Collection { get; set; }
    }
}
