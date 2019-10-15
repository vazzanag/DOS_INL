using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventStakeholder_Item : ISaveTrainingEventStakeholder_Item
    { 
        public Int64? TrainingEventID { get; set; }
        public int? AppUserID { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
