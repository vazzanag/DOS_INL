using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Data
{
    public class ReferenceTablesEntity : IReferenceTablesEntity
    {
        public string Reference { get; set; }
        public string ReferenceData { get; set; }
    }
}
