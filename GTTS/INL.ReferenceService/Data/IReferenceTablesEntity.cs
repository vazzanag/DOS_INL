using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Data
{
    public interface IReferenceTablesEntity
    {
        string Reference { get; set; }
        string ReferenceData { get; set; }
    }
}
