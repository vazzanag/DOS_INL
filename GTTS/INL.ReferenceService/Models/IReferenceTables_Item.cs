using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public interface IReferenceTables_Item
    {
        string Reference { get; set; }
        string ReferenceData { get; set; }
    }
}
