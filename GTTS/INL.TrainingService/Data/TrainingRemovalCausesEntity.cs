using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Data
{
    public class TrainingRemovalCausesEntity : ITrainingRemovalCausesEntity
    {
        public int RemovalCauseID { get; set; }
        public int RemovalReasonID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
