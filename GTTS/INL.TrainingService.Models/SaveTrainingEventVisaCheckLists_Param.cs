using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventVisaCheckList_Param : ISaveTrainingEventVisaCheckLists_Param
    {
        public long TrainingEventID { get; set; }
        public long ModifiedByAppUserID { get; set; }
        public List<GetTrainingEventVisaCheckLists_Item> Collection { get; set; }
    }
}
