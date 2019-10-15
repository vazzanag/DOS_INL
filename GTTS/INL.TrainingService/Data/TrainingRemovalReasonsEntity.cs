using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Data
{
    public class TrainingRemovalReasonsEntity : ITrainingRemovalReasonsEntity
    {
        public int RemovalReasonID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public byte SortControl { get; set; }

    }
}
