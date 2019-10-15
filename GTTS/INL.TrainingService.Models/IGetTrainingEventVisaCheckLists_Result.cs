using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventVisaCheckLists_Result
    {
        List<GetTrainingEventVisaCheckLists_Item> Collection { get; set; }
    }
}
