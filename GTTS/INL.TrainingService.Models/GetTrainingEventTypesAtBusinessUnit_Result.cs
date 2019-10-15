using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventTypesAtBusinessUnit_Result : IGetTrainingEventTypesAtBusinessUnit_Result
    {
        public List<TrainingEventTypesAtBusinessUnit_Item> Collection { get; set; }
    }
}
