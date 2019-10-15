using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventVisaCheckLists_Param
    {
        long TrainingEventID { get; set; }
        long ModifiedByAppUserID { get; set; }
        List<GetTrainingEventVisaCheckLists_Item> Collection { get; set; }
    }
}
