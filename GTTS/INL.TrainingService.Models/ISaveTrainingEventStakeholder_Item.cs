using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventStakeholder_Item
    {
        Int64? TrainingEventID { get; set; }
        int? AppUserID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
    }
}
