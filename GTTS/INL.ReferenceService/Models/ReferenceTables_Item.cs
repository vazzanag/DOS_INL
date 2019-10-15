using System;
using System.Collections.Generic;
using System.Text;
using INL.ReferenceService.Data;

namespace INL.ReferenceService.Models
{
    public class ReferenceTables_Item : IReferenceTables_Item
    {
        public string Reference { get; set; } 
        public string ReferenceData { get; set; }
    }
}
