using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventTypesAtBusinessUnit_Result
    {
        List<TrainingEventTypesAtBusinessUnit_Item> Collection { get; set; }
    }
}
