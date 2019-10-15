using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class TrainingReference_Result
    {
        public TrainingReference_Result()
        {
            ReferenceTables = new TrainingReferences_Item();
        }
        public TrainingReferences_Item ReferenceTables { get; set; }
    }
}
