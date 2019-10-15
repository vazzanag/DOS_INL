using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventVisaCheckLists_Result : IGetTrainingEventVisaCheckLists_Result
    {
        public List<GetTrainingEventVisaCheckLists_Item> Collection { get; set; }
    }
}
